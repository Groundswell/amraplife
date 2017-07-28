class BotSessionMigration < ActiveRecord::Migration
	def change


		create_table :bot_sessions do |t|
			t.belongs_to 	:user
			t.string		:provider
			t.string		:uid
			t.hstore 		:properties, default: {}
			t.timestamps
		end
		add_index :bot_sessions, [ :provider, :uid, :user_id ]
		add_index :bot_sessions, [ :updated_at ]


	end
end
