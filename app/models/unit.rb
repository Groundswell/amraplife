
class Unit < ActiveRecord::Base
	before_create	:set_aliases
	enum unit_type: { 'custom' => 0, 'volume' => 1, 'weight' => 2, 'length' => 3, 'time' => 4, 'percent' => 5, 'pressure' => 6, 'energy' => 7 }

	belongs_to :base_unit, class_name: 'Unit'

	# the imperial correlate maps metric units to their imperial counter-parts.
	# e.g. kg correlates to lb (not oz), cm correlates to in, etc....
	belongs_to :imperial_correlate, class_name: 'Unit'

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

	def to_s
		self.name
	end



	private
		def set_aliases
			return false if self.name.blank? && self.abbrev.blank?
			self.aliases << self.name.parameterize unless self.aliases.include?( self.name.parameterize ) 
			self.aliases << self.abbrev unless ( self.aliases.include?( self.abbrev ) || self.abbrev.blank? )
			self.aliases.each_with_index do |value, index|
				self.aliases[index] = value.parameterize if value.length > 1 unless value.blank?
			end
			self.aliases = self.aliases.sort.reject{ |a| a.blank? }
		end
end