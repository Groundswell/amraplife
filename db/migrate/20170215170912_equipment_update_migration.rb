class EquipmentUpdateMigration < ActiveRecord::Migration
	def change
		add_column :equipment, :status, :integer, default: 0

		create_table :equipment_models do |t|
			t.references	:equipment
			t.string 		:title
			t.string		:slug
			t.string 		:brand
			t.text			:description
			t.text 			:content
			t.text			:avatar
			t.integer 		:status, default: 0
			t.hstore 		:properties, default: {}
			t.timestamps 
		end
		add_index :equipment_models, :equipment_id
		add_index :equipment_models, :slug, unique: true
	end
end
