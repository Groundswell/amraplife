class TeamsMigration < ActiveRecord::Migration
	def change


		create_table :teams do |t|
			t.string		:name
			t.string		:slack_team_id
			t.hstore		:properties, 	default: {}
			t.timestamps
		end
		add_index :teams, :name
		add_index :teams, :slack_team_id

		create_table :team_users do |t|
			t.belongs_to	:team
			t.belongs_to	:user
			t.string		:slack_user_id
			t.hstore		:properties, 	default: {}
			t.timestamps
		end
		add_index :team_users, :team_id
		add_index :team_users, :user_id
		add_index :team_users, [ :slack_user_id, :user_id ]

	end
end
