class Metric < ActiveRecord::Base

	before_save	:set_aliases

	validate :unique_aliases

	belongs_to :movement
	belongs_to :user

	has_many 	:observations, as: :observed, dependent: :destroy


	include FriendlyId
	friendly_id :title, use: [ :slugged ]

	def self.find_by_alias( term )
		where( ":term = ANY( aliases )", term: term ).first
	end




	def aliases_csv
		self.aliases.join( ', ' )	
	end

	def aliases_csv=( aliases_csv )
		self.aliases = aliases_csv.split( /,\s*/ )
	end


	private
		def set_aliases
			self.aliases << self.slug unless self.aliases.include?( self.slug )
		end

		def unique_aliases
			existing_aliases = Metric.where.not( id: self.id ).pluck( :aliases ).flatten
			self.aliases = self.aliases.uniq - existing_aliases
		end
	
end