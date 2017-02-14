
class Place < ActiveRecord::Base

	enum status: { 'draft' => 0, 'active' => 1, 'archive' => 2, 'trash' => 3 }

	validates		:title, presence: true, unless: :allow_blank_title?

	attr_accessor	:slug_pref

	include SwellMedia::Concerns::URLConcern
	include SwellMedia::Concerns::AvatarAsset
	include SwellMedia::Concerns::ExpiresCache

	has_many :equipment_places
	has_many :equipments, through: :eqipment_places

	mounted_at '/places'

	include FriendlyId
	friendly_id :slugger, use: [ :slugged, :history ]

	acts_as_taggable_array_on :tags


	def self.published( args = {} )
		self.active
	end

	def published?
		active?
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

end