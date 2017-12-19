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
			'sum_value' => 'Sum Values',
			'avg_value' => 'Average Value', 
			'count' => 'Number of Observations'
		}
	end



	def display_value( opts={} )
		opts[:precision] ||= 2
		# UnitService.new( val: self.value, stored_unit: self.unit, display_unit: self.display_unit, use_metric: self.user.use_metric, show_units: opts[:show_units] ).convert_to_display
		if self.unit.nil?
			"#{value}"
		elsif self.unit.is_time?
			return ChronicDuration.output( self.value, format: :chrono )
		elsif self.unit.is_percent?
			return "#{( self.value * 100.to_f ).round( opts[:precision] )}%"
		else
			stored_unit = self.unit.base_unit
			if stored_unit.present?
				value = ( self.value / self.unit.conversion_factor.to_f ).round( opts[:precision] )
			else
				value = self.value
			end
			"#{value} #{self.unit.abbrev}"
		end
	end


end