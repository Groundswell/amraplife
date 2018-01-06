
class Unit < ActiveRecord::Base
	before_create	:set_aliases
	enum unit_type: { 'nada' => -1, 'custom' => 0, 'volume' => 1, 'weight' => 2, 'length' => 3, 'time' => 4, 'percent' => 5, 'pressure' => 6, 'energy' => 7 }

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

	def self.pound
		self.friendly.find( 'pound' )
	end

	def self.sec
		self.friendly.find( 'second' )
	end

	def self.calorie
		self.friendly.find( 'calorie' )
	end


	def aliases_csv
		self.aliases.join( ', ' )
	end

	def aliases_csv=( aliases_csv )
		self.aliases = aliases_csv.split( /,\s*/ )
	end

	def convert_to_base( val, opts={} )

		if self.is_time?
			if not( val.strip.match( /\D+/ ) )
				val = "#{val} #{self.name}"
			end
			return ChronicDuration.parse( val )
		elsif self.is_percent?
			return val.to_f / 100
		elsif self.base_unit.present?
			return val.to_f * self.conversion_factor
		else
			return val.to_f
		end
	end


	def convert_from_base( val, opts={} )
		# by default, return a formatted string
		# show_units: false should just return a float
		opts[:show_units] = true unless opts[:show_units] == false
		opts[:precision] ||= 2

		val = val.to_f

		if self.is_nada?
			return "#{val}"
		elsif self.is_time?
			if opts[:show_units]
				return ChronicDuration.output( val, format: :long )
			else
				return ChronicDuration.output( val, format: :chrono )
			end
		elsif self.is_percent?
			if opts[:show_units]
				return "#{( val * 100.to_f ).round( opts[:precision] )}%"
			else
				return "#{( val * 100.to_f ).round( opts[:precision] )}"
			end
		else
			if self.base_unit.present?
				value = ( val / self.conversion_factor.to_f ).round( opts[:precision] )
			else
				value = val
			end
			if opts[:show_units]
				return "#{value} #{self.abbrev}"
			else
				return value
			end
		end

	end


	def is_nada?
		self.unit_type == 'nada'
	end

	def is_percent?
		self.unit_type == 'percent'
	end

	def is_time?
		self.unit_type == 'time'
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