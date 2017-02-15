
class Equipment < ActiveRecord::Base 

	enum status: { 'draft' => 0, 'active' => 1, 'archive' => 2, 'trash' => 3 }

	validates		:title, presence: true, unless: :allow_blank_title?

	attr_accessor	:slug_pref
	
	acts_as_nested_set
	
	has_many :movements
	has_many :workout_movements
	has_many :workouts, -> { distinct }, through: :workout_movements


	include SwellMedia::Concerns::URLConcern
	include SwellMedia::Concerns::AvatarAsset
	#include SwellMedia::Concerns::ExpiresCache

	mounted_at '/equipment'

	include FriendlyId
	friendly_id :slugger, use: [ :slugged, :history ]
	

	def self.published
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
		self.content.present? && self.active?
	end

	def sanitized_description
		ActionView::Base.full_sanitizer.sanitize( self.description )
	end

	def slugger
		if self.slug_pref.present?
			self.slug = nil # friendly_id 5.0 only updates slug if slug field is nil
			return self.slug_pref
		else
			return self.title
		end
	end

	def tags_csv
		self.tags.join( ', ' )	
	end

	def tags_csv=( tags_csv )
		self.tags = tags_csv.split( /,\s*/ )
	end
	

	def to_s
		self.title
	end

	private 
		def allow_blank_title?
			self.slug_pref.present?
		end
end