
class Recipe < ActiveRecord::Base

	enum status: { 'draft' => 0, 'active' => 1, 'archive' => 2, 'trash' => 3 }

	validates		:title, presence: true, unless: :allow_blank_title?

	attr_accessor	:slug_pref, :category_name

	before_save	:set_publish_at

	include SwellMedia::Concerns::URLConcern
	include SwellMedia::Concerns::AvatarAsset
	#include SwellMedia::Concerns::ExpiresCache

	belongs_to :recipe_category, foreign_key: :category_id

	has_many :ingredients
	has_many :foods, through: :ingredients

	mounted_at '/recipes'

	include FriendlyId
	friendly_id :slugger, use: [ :slugged, :history ]

	acts_as_taggable_array_on :tags


	def self.published( args = {} )
		where( "publish_at <= :now", now: Time.zone.now ).active
	end

	def published?
		active? && publish_at < Time.zone.now
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
			type: 'Article',
			og: {
				"article:published_time" => self.publish_at.iso8601,
			},
			data: {
				'url' => self.url,
				'name' => self.title,
				'description' => self.sanitized_description,
				'datePublished' => self.publish_at.iso8601,
				'image' => self.avatar
			}

		}
	end

	def sanitized_content
		ActionView::Base.full_sanitizer.sanitize( self.content )
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
		self.tags.join(',')
	end

	def tags_csv=(tags_csv)
		self.tags = tags_csv.split(/,\s*/)
	end


	private
		def allow_blank_title?
			self.slug_pref.present?
		end

		def set_publish_at
			# set publish_at
			self.publish_at ||= Time.zone.now
		end
end
