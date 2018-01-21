class V1ReleaseMigration < ActiveRecord::Migration
	def change
		rename_column	:metrics, :metric_type, :default_value_type 
		add_column		:metrics, :category_id, :integer

		add_column 		:units, :custom_base_unit_id, :integer
		add_column 		:units, :custom_conversion_factor, :integer
	end
	# add_index 		:metrics, :category_id
	#add_index 		:units, :custom_base_unit_id
end
