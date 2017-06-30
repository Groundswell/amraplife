class UpdateObservationsMigration < ActiveRecord::Migration
	def change
		add_column	:metrics, :target_period, :string # nil = all-time, day, week, month
		add_column	:metrics, :target_type, :string, default: 'sum_value' # avg_value, obs_count, max_value, min_value
		add_column 	:metrics, :target_min, :float, default: 0
		add_column 	:metrics, :target_max, :float, default: 0

		add_column 	:metrics, :availability, :integer, default: 0



		add_column	:observations, :raw_input, :text
	end
end
