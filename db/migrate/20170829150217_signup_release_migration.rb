class SignupReleaseMigration < ActiveRecord::Migration
	def change
		create_table :targets do |t|
			t.references	:parent_obj, polymorphic: true
			t.references 	:user 
			t.references 	:unit
			t.string		:target_type, default: "value"
			t.float 		:value 
			t.float 		:min 
			t.float 		:max
			t.string 		:direction, default: "at_most"
			t.string 		:period,    default: "all_time"
			t.datetime 		:start_at
			t.datetime 		:end_at
			t.integer 		:status, 	default: 1
			t.timestamps
		end
		add_index :targets, [ :parent_obj_id, :parent_obj_type ]
		add_index :targets, :unit_id
		add_index :targets, :user_id

		if column_exists?( :metrics, :unit )
			remove_column :metrics, :unit, :string
			remove_column :metrics, :display_unit, :string
		end

		if column_exists?( :metrics, :target )
			remove_column :metrics, :target
			remove_column :metrics, :target_direction
			remove_column :metrics, :target_unit
			remove_column :metrics, :target_period
			remove_column :metrics, :target_type
			remove_column :metrics, :target_min
			remove_column :metrics, :target_max
		end

		if column_exists?( :observations, :display_unit )
			remove_column :observations, :display_unit
			remove_column :observations, :unit
		end


		create_table :units do |t| 
			t.references 	:base_unit
			t.references 	:imperial_correlate
			t.references 	:user
			t.float 		:conversion_factor, default: 1
			t.string		:name
			t.string		:slug
			t.string		:abbrev
			t.integer 		:unit_type, 		default: 0 # custom, volume, length, mass, time
			t.text			:aliases,     		default: [], array: true
			t.boolean 		:imperial, 			default: true
			t.timestamps
		end
		add_index 	:units, :user_id
		add_index 	:units, :base_unit_id
		add_index 	:units, :imperial_correlate_id

		add_column		:metrics, :unit_id, :integer
		add_column		:metrics, :default_period, :string, default: :all_time
		add_column		:metrics, :created_at, :datetime
		add_column		:metrics, :updated_at, :datetime


		add_column		:observations, :unit_id, :integer

		rename_column :users, :use_metric, :use_imperial_units
		change_column_default :users, :use_imperial_units, true

	end
end
