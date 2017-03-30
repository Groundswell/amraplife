
class Place < ActiveRecord::Base

	if defined?( Elasticsearch::Model )

		include Elasticsearch::Model

		settings index: { number_of_shards: 1 } do
			mappings dynamic: 'false' do
				indexes :id, type: 'integer'
				indexes :slug, index: :not_analyzed
				indexes :created_at, type: 'date'
				indexes :title, analyzer: 'english', index_options: 'offsets'
				indexes :title_downcase_raw, type: :string, index: :not_analyzed
				indexes :description, analyzer: 'english', index_options: 'offsets'
				indexes :content, analyzer: 'english', index_options: 'offsets'
				indexes :published?, type: 'boolean'

				indexes :location, type: 'geo_point'

				indexes :zip, analyzer: 'english', index_options: 'offsets'
				indexes :city, analyzer: 'english', index_options: 'offsets'
				indexes :state, analyzer: 'english', index_options: 'offsets'
				indexes :address1, analyzer: 'english', index_options: 'offsets'
				indexes :address2, analyzer: 'english', index_options: 'offsets'

				indexes :tags, type: 'nested' do
					indexes :name, analyzer: 'english', index_options: 'offsets'
					indexes :raw_name, index: :not_analyzed
					indexes :name_downcase, analyzer: 'english', index_options: 'offsets'
					indexes :raw_name_downcase, index: :not_analyzed
				end
			end
		end

	end

	enum status: { 'draft' => 0, 'active' => 1, 'archive' => 2, 'trash' => 3 }

	validates		:title, presence: true, unless: :allow_blank_title?

	attr_accessor	:slug_pref

	include SwellMedia::Concerns::URLConcern
	include SwellMedia::Concerns::AvatarAsset
	#include SwellMedia::Concerns::ExpiresCache

	has_many :assets, as: :parent_obj, dependent: :destroy, class_name: 'SwellMedia::Asset'
	has_many :equipment_places
	has_many :equipments, through: :eqipment_places

	mounted_at '/places'

	include FriendlyId
	friendly_id :slugger, use: [ :slugged, :history ]

	acts_as_taggable_array_on :tags

	def featured_video
		video_assets.active.where( use: 'featured' ).first
	end

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

	def video_assets
		self.assets.where( asset_type: 'video' )
	end


	def as_indexed_json(options={})
		{
			id:					self.id,
			slug:				self.slug,
			created_at:			self.created_at,
			title: 				self.title,
			title_downcase_raw: self.title.try(:downcase),
			description:		self.description,
			content:			self.content,
			location:			{ lat: self.lat.to_f, lon: self.lon.to_f },
			city:				self.city,
			state:				self.state,
			zip:				self.zip,
			address1:			self.address1,
			address2:			self.address2,
			published?:			self.published?,
			tags:				self.tags.collect{ |tag| { name: tag, raw_name: tag, name_downcase: tag.downcase, raw_name_downcase: tag.downcase } },
		}.as_json
	end

	private
		def allow_blank_title?
			self.slug_pref.present?
		end

end
