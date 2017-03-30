
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

				indexes :location, type: 'geo_point', as: 'location'

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



	# e.g. Place.record_search( lat: 1, lon: 9, text: 'live amrap' )
	# e.g. Place.record_search( text: 'live amrap' )
	# e.g. Place.record_search( 'live amrap' )
	def self.record_search( options = {} )
		options = { text: options } if options.is_a? String
		page = options.delete(:page)
		per = options.delete(:per) || 10

		query = Jbuilder.encode do |json|
			json.query do
				json.filtered do
					json.query do

						json.bool do
							json.must do
								if options[:tags].present?

									json.child! do
										json.nested do
											json.path 'tags'
											json.query do
												if options[:tags].is_a? Array
													json.terms do
														json.set! 'tags.raw_name_downcase', options[:tags].collect(&:downcase)
													end
												else
													json.term do
														json.set! 'tags.raw_name_downcase', options[:tags].downcase
													end
												end
											end
										end
									end

								end

								if options.has_key? :published?
									json.child! do
										json.term do
											json.published? options[:published?]
										end
									end
								end

							end

							json.should do

								if options[:text].present?
									json.child! do
										json.match do
											json.title do
												json.query options[:text]
												json.boost 10
											end
										end
									end

									json.child! do
										json.match do
											json.description do
												json.query options[:text]
											end
										end
									end

								end

							end

							json.minimum_should_match 1

						end
					end

					json.filter do
						if options.has_key? :lat
							json.geo_distance do
								json.distance options[:distance] || '12km'

								json.location do
									json.lat options[:lat].to_f
									json.lon options[:lon].to_f
								end

							end
						end

					end

				end
			end
		end

		puts query



		self.search( query ).page( page ).per( per ).records

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
