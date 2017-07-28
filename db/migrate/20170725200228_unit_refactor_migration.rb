class UnitRefactorMigration < ActiveRecord::Migration
	def change
		add_column 	:metrics, :display_unit, :string
		add_column 	:observations, :display_unit, :string

		rename_column :users, :use_metric_units, :use_metric

		remove_column 	:observations, :sub_value
		remove_column 	:observations, :sub_unit
	end
end
