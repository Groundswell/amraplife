class UnitRefactorMigration < ActiveRecord::Migration
	def change
		add_column 	:metrics, :display_unit, :string
		add_column 	:observations, :display_unit, :string
	end
end
