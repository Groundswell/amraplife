class BotLaunchMigration < ActiveRecord::Migration
	def change

		reversible do |dir|
			dir.up do
				change_column_default 	:metrics, :unit, nil
				change_column_default 	:metrics, :target_min, nil
				change_column_default 	:metrics, :target_max, nil
				change_column_default 	:metrics, :target_type, 'value'
				change_column_default 	:metrics, :target_period, 'all_time'
				add_column 				:metrics, :target_direction, :string, default: 'at_most'
				

				change_column_default 	:observations, :unit, nil
				change_column_default 	:observations, :sub_unit, nil
				change_column_default 	:observations, :sub_value, nil

				add_column 				:users, :use_metric_units, :boolean, default: false

			end
			dir.down do
				change_column_default 	:metrics, :unit, 'sec'
				change_column_default 	:metrics, :target_min, 0
				change_column_default 	:metrics, :target_max, 0
				change_column_default 	:metrics, :target_type, 'daily_sum_max'
				add_column				:metrics, :target_period, :string

				change_column_default 	:observations, :unit, 'sec'
				change_column_default 	:observations, :sub_unit, 0
				change_column_default 	:observations, :sub_value, 0

				remove_column :users, :use_metric_units
			end
		end

		

	end
end
