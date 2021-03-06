
class Movement < ActiveRecord::Base

	enum status: { 'draft' => 0, 'active' => 1, 'archive' => 2, 'trash' => 3 }

	validates		:title, presence: true, unless: :allow_blank_title?

	include SwellMedia::Concerns::URLConcern
	include SwellMedia::Concerns::AvatarAsset
	#include SwellMedia::Concerns::ExpiresCache

	validate :unique_aliases

	attr_accessor	:slug_pref

	
	
	belongs_to :equipment 

	has_many :workout_movements 
	has_many :workouts, through: :workout_movements 

	acts_as_nested_set

	mounted_at '/movements'
	
	include FriendlyId
	friendly_id :title, use: [ :slugged, :history ]


	def self.find_by_alias( term )
		where( ":term = ANY( aliases )", term: term ).first
	end

	def self.published( args = {} )
		where( "char_length(content) > 0" ).active
	end

	



	def aliases_csv
		self.aliases.join( ', ' )	
	end

	def aliases_csv=( aliases_csv )
		self.aliases = aliases_csv.split( /,\s*/ )
	end

	def page_meta
		if self.title.present?
			title = "#{self.title} )°( #{SwellMedia.app_name}"
		else
			title = SwellMedia.app_name
		end

		return {
			page_title: title,
			title: self.title,
			description: self.sanitized_description,
			image: self.avatar,
			url: self.url,
			twitter_format: 'summary_large_image',
			type: 'article',
			og: {
				"article:published_time" => self.created_at.iso8601
			},
			data: {
				'url' => self.url,
				'name' => self.title,
				'description' => self.sanitized_description,
				'datePublished' => self.created_at.iso8601,
				'image' => self.avatar
			}

		}
	end

	def published?
		self.active? && self.content.present?
	end

	def sanitized_content
		ActionView::Base.full_sanitizer.sanitize( self.content )
	end

	def sanitized_description
		ActionView::Base.full_sanitizer.sanitize( self.description )
	end

	def tags_csv
		self.tags.join(',')
	end

	def tags_csv=(tags_csv)
		self.tags = tags_csv.split(/,\s*/)
	end

	def to_s
		self.title
	end



	private

		def allow_blank_title?
			self.slug_pref.present?
		end

		def unique_aliases
			existing_aliases = Movement.where.not( id: self.id ).pluck( :aliases ).flatten
			self.aliases = self.aliases.uniq - existing_aliases
		end
	
end