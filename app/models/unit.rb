
class Unit < ActiveRecord::Base
	before_create	:set_aliases
	enum unit_type: { 'custom' => 0, 'volume' => 1, 'weight' => 2, 'length' => 3, 'time' => 4, 'percent' => 5, 'pressure' => 6, 'energy' => 7 }

	belongs_to :base_unit, class_name: 'Unit'

	include FriendlyId
	friendly_id :name, use: :slugged

	# acts_as_taggable_array_on :aliases




	def self.find_by_alias( term )
		term = term.parameterize if term.present? && term.length > 1
		where( ":term = ANY( aliases )", term: term ).first
	end

	def aliases_csv
		self.aliases.join( ', ' )
	end

	def aliases_csv=( aliases_csv )
		self.aliases = aliases_csv.split( /,\s*/ )
	end

	def is_time?
		self.unit_type == 'time'
	end

	def is_percent?
		self.unit_type == 'percent'
	end



	private
		def set_aliases
			return false if self.name.blank? && self.abbrev.blank?
			self.aliases << self.name.parameterize unless self.aliases.include?( self.name.parameterize ) 
			self.aliases << self.abbrev unless self.aliases.include?( self.abbrev )
			self.aliases.each_with_index do |value, index|
				self.aliases[index] = value.parameterize if value.length > 1
			end
			self.aliases = self.aliases.sort.reject{ |a| a.blank? }
		end
end