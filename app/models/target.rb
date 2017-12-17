class Target < ActiveRecord::Base

	enum status: { 'archive' => 0, 'active' => 1, 'inactive' => 3 }

	belongs_to :parent_obj, polymorphic: true
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
			'sum_value' => 'Sum Values',
			'avg_value' => 'Average Value', 
			'count' => 'Number of Observations'
		}
	end


end