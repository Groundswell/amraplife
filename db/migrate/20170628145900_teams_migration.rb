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

	end
end
