class MetricsMigration < ActiveRecord::Migration
	def change
		add_column :metrics, :user_id, :integer
		add_column :metrics, :metric_type, :string # activity, stat, benchmark
		add_column :metrics, :description, :text
		change_column_default :metrics, :unit, 'sec'
		change_column_default :observations, :unit, 'sec'
		change_column_default :observations, :sub_unit, 'rep'
	end
end
