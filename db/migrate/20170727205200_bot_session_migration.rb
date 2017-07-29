class BotSessionMigration < ActiveRecord::Migration
	def change


		create_table :bot_sessions do |t|
			t.belongs_to 	:user
			t.string		:provider
			t.string		:uid
			t.string 		:expected_intents, array: true, default: '{}'
			t.hstore 		:context, default: {}
			t.hstore 		:properties, default: {}
			t.timestamps
		end
		add_index :bot_sessions, [ :provider, :uid, :user_id ]
		add_index :bot_sessions, [ :updated_at ]


		add_column :workouts, :description_speech, :text
		add_column :workouts, :start_speech, :text

	end
end
