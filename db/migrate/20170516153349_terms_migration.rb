class TermsMigration < ActiveRecord::Migration
	def change
		add_column :movements, :movement_type, :string

		create_table :terms do |t|
			t.string	:title
			t.string	:slug
			t.text 		:description
			t.text 		:content
			t.text		:aliases, array: true, default: []
			t.integer 	:status, default: 1
			t.timestamps
		end

	end
end
