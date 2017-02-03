
class Movement < ActiveRecord::Base

	validate :unique_aliases
	
	belongs_to :equipment 

	has_many :workout_movements 
	has_many :workouts, through: :workout_movements 


	acts_as_nested_set
	
	include FriendlyId
	friendly_id :title, use: [ :slugged, :history ]


	def self.find_by_alias( term )
		where( ":term = ANY( aliases )", term: term ).first
	end



	def aliases_csv
		self.aliases.join( ', ' )	
	end

	def aliases_csv=( aliases_csv )
		self.aliases = aliases_csv.split( /,\s*/ )
	end

	def to_s
		self.title
	end



	private

		def unique_aliases
			existing_aliases = Movement.where.not( id: self.id ).pluck( :aliases ).flatten
			self.aliases = self.aliases.uniq - existing_aliases
		end
	
end