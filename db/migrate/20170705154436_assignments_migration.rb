class AssignmentsMigration < ActiveRecord::Migration
	def change
		add_column	:metrics, :target, :float

		create_table :assignments do |t|
			t.references 	:assigned, polymorphic: true
			t.references 	:user
			t.references 	:assigned_by
			t.integer 		:status, default: 1
			t.integer 		:availability, default: 0
			t.string		:title
			t.text 			:description
			t.text 			:notes
			t.datetime 		:starts_at
			t.datetime 		:ends_at
			t.datetime 		:due_at
			t.hstore 		:properties
			t.timestamps
		end
		add_index :assignments, [ :assigned_id, :assigned_type ]
		add_index :assignments, :user_id
		add_index :assignments, :assigned_by_id

	end
end
