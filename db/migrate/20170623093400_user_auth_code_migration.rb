class UserAuthCodeMigration < ActiveRecord::Migration
	def change
		add_column :users, :authorization_code, :text
		add_index :users, :authorization_code
	end
end
