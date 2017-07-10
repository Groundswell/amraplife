class UserInputMigration < ActiveRecord::Migration
	def change
		remove_column	:observations, :raw_input
		
		create_table :user_inputs do |t|
			t.references	:user 
			t.references 	:created_obj, polymorphic: true 
			t.text 			:content
			t.timestamps
		end
		add_index :user_inputs, :user_id
		add_index :user_inputs, [ :created_obj_id, :created_obj_type ]


	end
end
