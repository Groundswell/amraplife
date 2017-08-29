class SignupReleaseMigration < ActiveRecord::Migration
	def change
		create_table :targets do |t|
			t.references	:parent_obj
			t.references 	:user 
			t.float 		:value 
			t.float 		:min 
			t.float 		:max
			t.string 		:direction, default: "at_most"
			t.string 		:period,    default: "all_time"
			t.string 		:unit
			t.datetime 		:start_at
			t.datetime 		:end_at
			t.integer 		:status
			t.timestamps
		end
	end
end
