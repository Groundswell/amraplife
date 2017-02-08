
class Movement < ActiveRecord::Base

	enum status: { 'draft' => 0, 'active' => 1, 'archive' => 2, 'trash' => 3 }

	include SwellMedia::Concerns::URLConcern
	include SwellMedia::Concerns::AvatarAsset
	include SwellMedia::Concerns::TagArrayConcern

	validate :unique_aliases
	
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
		self.active
	end

	



	def aliases_csv
		self.aliases.join( ', ' )	
	end

	def aliases_csv=( aliases_csv )
		self.aliases = aliases_csv.split( /,\s*/ )
	end

	def published?
		active?
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

		def unique_aliases
			existing_aliases = Movement.where.not( id: self.id ).pluck( :aliases ).flatten
			self.aliases = self.aliases.uniq - existing_aliases
		end
	
end