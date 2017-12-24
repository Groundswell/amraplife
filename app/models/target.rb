class Target < ActiveRecord::Base

	enum status: { 'archive' => 0, 'active' => 1, 'inactive' => 3 }

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
			'daily' => 'per Day',
			'weekly' => 'per Week',
			'monthly' => 'per Month',
			'all_time' => 'All Time'
		}
	end

	def self.target_types
		{
			'value' => 'Value',
			'sum_value' => 'Total',
			'avg_value' => 'Average', 
			'count' => 'Number of Observations'
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


end