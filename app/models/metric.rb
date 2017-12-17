class Metric < ActiveRecord::Base

	before_create 	:set_defaults
	validate 		:unique_aliases

	validates :title, presence: true

	enum availability: { 'just_me' => 0, 'trainer' => 1, 'team' => 3, 'community' => 5, 'anyone' => 10 }

	belongs_to :movement
	belongs_to :user
	

	has_many 	:observations, as: :observed, dependent: :destroy
	has_many 	:targets, as: :parent_obj, dependent: :destroy

	belongs_to :unit

	attr_accessor :reassign_to_metric_id


	include FriendlyId
	friendly_id :slugger, use: [ :slugged ]


	def self.find_by_alias( term )
		return false if term.blank?
		where( ":term = ANY( aliases )", term: term.parameterize ).first
	end

	def aliases_csv
		self.aliases.join( ', ' )
	end

	def aliases_csv=( aliases_csv )
		self.aliases = aliases_csv.split( /,\s*/ )
	end

	def slugger
		"#{self.title}#{self.user_id}"
	end

	def total_for_day( day=Time.zone.now )
		self.observations.for_day( day ).sum( :value )
	end

	private
		def set_defaults
			self.aliases << self.title.parameterize unless self.aliases.include?( self.title.parameterize )
			self.aliases.each_with_index do |value, index|
				self.aliases[index] = value.parameterize
			end
			self.aliases = self.aliases.sort
		end

		def unique_aliases
			existing_aliases = Metric.where( user_id: self.user_id ).where.not( id: self.id ).pluck( :aliases ).flatten
			self.aliases = self.aliases.uniq - existing_aliases
		end

end
