class Metric < ActiveRecord::Base

	before_create 	:set_defaults
	validate 		:unique_aliases

	enum availability: { 'just_me' => 0, 'trainer' => 1, 'team' => 3, 'community' => 5, 'anyone' => 10 }

	belongs_to :movement
	belongs_to :user

	has_many 	:observations, as: :observed, dependent: :destroy

	attr_accessor :reassign_to_metric_id


	include FriendlyId
	friendly_id :slugger, use: [ :slugged ]


	def self.convert_to_display( num, obj, opts={} )
		precision = opts[:precision] || 2

		if num.present? && obj.unit == 's'
			ChronicDuration.output( num, format: :chrono )
		elsif num.present?
			unit = obj.display_unit
			if not( obj.user.use_metric_units? ) 
				unit = Metric.convert_to_imperial( obj.display_unit )
			end
			begin
				value = Unitwise( num, obj.unit ).convert_to( unit ).to_f.round( precision )
			rescue
				value = num
			end
			return value == 1 ? "#{value} #{unit}" : "#{value} #{unit}s"
		else
			nil
		end
	end

	def self.convert_to_imperial( unit )
		if Metric.imperial_units[ unit ].present?
			unit = Metric.imperial_units[ unit ]
		else
			unit
		end
	end

	def self.find_by_alias( term )
		where( ":term = ANY( aliases )", term: term.parameterize ).first
	end

	def self.imperial_units
		{
			'cm' => 'in',
			'm' => 'yd', 
			'km' => 'mi',

			'g'  => 'ounce',
			'kg' => 'lb',

			'ml' => 'fluid ounce',
			'l' => 'gallon'
		}		
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
			self.display_unit ||= self.unit
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
