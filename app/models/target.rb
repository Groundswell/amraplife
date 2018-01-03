class Target < ActiveRecord::Base

	enum status: { 'archive' => 0, 'active' => 1, 'inactive' => 3 }

	before_create 	:set_defaults

	belongs_to :parent_obj, polymorphic: true
	belongs_to :unit
	belongs_to :user

	

	def self.directions
		{
			'at_most' => 'at Most',
			'at_least' => 'at Least',
			'exactly' => 'Exactly',
			'between' => 'Between'
		}
	end

	def self.periods
		{
			'hourly' => 'per Hour',
			'daily' => 'per Day',
			'weekly' => 'per Week',
			'monthly' => 'per Month',
			'yearly' => 'per Year',
			'all_time' => 'All Time'
		}
	end

	def self.target_types
		{
			'avg_value' 		=> 'Average Value',
			'count' 			=> 'Observation Frequency',
			'current_value' 	=> 'Current Value',
			'max_value' 		=> 'All-Time High',
			'min_Value'			=> 'All-Time Low',
			'sum_value' 		=> 'Accumulated Value'
		}
	end



	def display_value( opts={} )
		opts[:precision] ||= 2

		if self.unit.nil?
			"#{self.value}"
		else
			self.unit.convert_from_base( self.value, opts )
		end
	end

	def to_s
		"#{Target.directions[self.direction]} #{self.display_value} #{Target.target_types[self.target_type]} #{Target.periods[self.period]}."
	end


	private
		def set_defaults
			self.target_type ||= self.parent_obj.try( :metric_type )
		end


end