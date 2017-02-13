class CardsMigration < ActiveRecord::Migration
	def change

		create_table :card_designs do |t|
			t.string	:title
			t.string 	:slug
			t.string	:avatar
			t.text 		:description
			t.integer 	:status, default: 1 
			t.timestamps
		end
		add_index :card_designs, :slug, unique: true

		create_table :cards do |t|
			t.references 	:card_design 
			t.string 		:pub_id
			t.string 		:from_name 
			t.string 		:from_email 
			t.string 		:to_name
			t.string 		:to_email
			t.text 			:message
			t.boolean 		:viewed, default: false
			t.timestamps 
		end
		add_index :cards, :card_design_id
		add_index :cards, :to_email
		add_index :cards, :pub_id
		
	end
end
