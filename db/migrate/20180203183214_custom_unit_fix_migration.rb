class CustomUnitFixMigration < ActiveRecord::Migration
	def change
		change_column	:units, :custom_conversion_factor, :float
	end
end
