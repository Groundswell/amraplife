class MetricsMigration < ActiveRecord::Migration
	def change
		add_column :metrics, :user_id, :integer
		add_column :metrics, :metric_type, :string
		add_column :metrics, :description, :text
		
	end
end
