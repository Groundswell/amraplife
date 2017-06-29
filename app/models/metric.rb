class Metric < ActiveRecord::Base

	before_create 	:set_aliases
	validate 		:unique_aliases

	enum visibility: { 'only_me' => 0, 'trainer' => 1, 'team' => 3, 'community' => 5, 'anyone' => 10 }

	belongs_to :movement
	belongs_to :user

	has_many 	:observations, as: :observed, dependent: :destroy


	include FriendlyId
	friendly_id :slugger, use: [ :slugged ]

	def self.find_by_alias( term )
		where( ":term = ANY( aliases )", term: term ).first
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
		def set_aliases
			self.aliases << self.title.parameterize unless self.aliases.include?( self.title.parameterize )
		end

		def unique_aliases
			existing_aliases = Metric.where( user_id: self.user_id ).where.not( id: self.id ).pluck( :aliases ).flatten
			self.aliases = self.aliases.uniq - existing_aliases
		end
	
end