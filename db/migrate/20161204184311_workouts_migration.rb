
# workout has many movements
# movements require equipment
# can search for workouts that match your equipment
# workout has many segments
# segments are timed intervals to run the clock

class WorkoutsMigration < ActiveRecord::Migration
	def change
		
		create_table :equipment do |t|
			t.string 		:title
			t.string 		:slug
			t.references 	:parent #for variations e.g. different height plyo box
			t.integer 		:rgt
			t.integer 		:lft
			t.string 		:avatar
			t.text			:aliases, array: true, default: []
			t.text 			:description
			t.text 			:content
			t.string		:unit_type
			t.integer 		:unit
			t.string 		:tags, array: true, default: '{}'
			t.hstore		:properties, default: {}
			t.timestamps
		end
		add_index :equipment, :slug, unique: true
		add_index :equipment, :parent_id

		create_table :equipment_places do |t|
			t.references 	:place 
			t.references 	:equipment 
			t.string 		:notes 
			t.timestamps 
		end
		add_index :equipment_places, :place_id
		add_index :equipment_places, :equipment_id

		create_table :foods do |t|
			t.string 		:title
			t.string 		:slug
			t.string 		:description 
			t.text 			:content 
			t.string 		:avatar
			t.text 			:nutrition
			t.timestamps
		end
		add_index :foods, :slug, unique: true

		create_table :ingredients do |t|
			t.references 	:recipe 
			t.references 	:food
			t.string		:amount 
			t.string 		:unit 
			t.string 		:notes 
			t.timestamps 
		end
		add_index :ingredients, :recipe_id
		add_index :ingredients, :food_id
		
		create_table :metrics do |t| 
			# to keep lookup table for observations
			t.references 	:movement # for maxes & PRs  ??
			t.string 		:title
			t.string 		:slug
			t.text			:aliases, array: true, default: []
			t.string		:unit
		end
		add_index :metrics, :movement_id
		add_index :metrics, :slug, unique: true

		create_table :movements do |t|
			t.references 	:equipment  # required equipment
			t.references 	:movement_category  # bodyweight, warm-up, stretch ???
			t.references 	:parent #for variations
			t.integer 		:rgt
			t.integer 		:lft
			t.string 		:title
			t.string 		:slug 
			t.string 		:avatar
			t.text			:aliases, array: true, default: []
			t.string 		:description
			t.text 			:content 
			t.string 		:measured_by, default: :reps # reps, time, distance
			t.string 		:anatomy
			t.integer 		:status, default: 1
			t.string 		:tags, array: true, default: '{}'
			t.hstore		:properties, default: {}
			t.timestamps
		end
		add_index :movements, :equipment_id
		add_index :movements, :parent_id
		add_index :movements, :slug, unique: true

		create_table :movement_relationships do |t|
			t.references 	:movement 
			t.references 	:related_movement 
			t.string 		:relation_type, default: :variant # scale_up, scale_down 
			t.timestamps 
		end
		add_index :movement_relationships, :movement_id
		add_index :movement_relationships, :related_movement_id

		create_table :observations do |t| 
			t.string 		:tmp_id  			# for when observations are posted by the app
			t.references 	:user
			t.references 	:parent 			# nest segment results under parent workout result
			t.integer 		:lft
			t.integer 		:rgt
			t.references 	:observed, polymorphic: true
			t.string 		:title
			t.string 		:content
			t.float 		:value 
			t.float 		:sub_value, default: 0			# for add -on such as rounds (value) & addtnl reps (sub_value)
			t.string 		:unit, default: 'secs'			# lb, time, reps, etc
			t.string 		:sub_unit, default: 'reps'		# e.g. reps
			t.string 		:rx 				# rx or modifications, num-rep-max for lift maxes
			t.text 			:notes 
			t.datetime 		:started_at 
			t.datetime 		:ended_at 
			t.datetime 		:recorded_at
			t.hstore		:properties, default: {}
			t.timestamps 
		end
		add_index :observations, [:user_id, :tmp_id]
		add_index :observations, :parent_id

		create_table :places do |t|
			t.string 		:title 
			t.string 		:slug
			t.string 		:description 
			t.text 			:content
			t.string 		:avatar
			t.string 		:phone 
			t.string 		:address1
			t.string		:address2
			t.string 		:city
			t.string		:state 
			t.string 		:zip 
			t.string 		:lat 
			t.string 		:lon
			t.string		:hours
			t.string 		:cost
			t.integer 		:status, default: 1
			t.string 		:tags, array: true, default: '{}'
			t.hstore		:properties, default: {}
			t.timestamps
		end
		add_index :places, :slug, unique: true

		create_table :recipes do |t|
			t.string 		:title 
			t.string 		:description 
			t.text 			:content 
			t.string 		:avatar
			t.string 		:slug 
			t.string 		:prep_time 
			t.string 		:cook_time 
			t.string 		:serves 
			t.string 		:nutrition
			t.integer 		:status, default: 0
			t.datetime 		:publish_at
			t.timestamps
		end
		add_index :recipes, :slug, unique: true

		create_table :workouts do |t|
			t.string 		:title
			t.string 		:slug
			t.references 	:workout_category # bodyweight, metcon, ????
			t.string 		:workout_type 	# reps (amrap), rounds (rft), emom, tabata
			t.string 		:avatar
			t.string		:cover_img
			t.text 			:description
			t.text 			:content
			t.integer 		:total_duration # sum of segments
			t.integer 		:total_reps 	# sum of segments
			t.integer		:time_cap 		# seconds to cap out
			t.integer 		:status, default: 0
			t.datetime		:publish_at
			t.string 		:tags, array: true, default: '{}'
			t.timestamps
			t.hstore		:properties, default: {}
		end
		add_index :workouts, :slug, unique: true

		# just to keep track & query workouts based on movement e.g. which workouts prescribe situps?
		# also, query wokouts based on equipment required. e.g. I only have a jumprope, which workouts can I do?
		create_table :workout_movements do |t|
			t.references 	:workout 
			t.references 	:movement 
			t.references 	:equipment
			t.string 		:m_rx
			t.string 		:f_rx
			t.timestamps 
		end
		add_index :workout_movements, :workout_id
		add_index :workout_movements, :movement_id
		add_index :workout_movements, :equipment_id

		create_table :workout_segments do |t|
			t.references 	:workout
			t.integer 		:seq, default: 1
			t.string 		:title
			t.text 			:description 					# in seconds
			t.text 			:content
			t.string 		:segment_type, default: :ft 	# ft, amrap, rft (w/rpt_count), emom, tabata (rpt 8), accumulate, warmup, mobility, strength, rest
			t.string 		:clock_dir, default: :down
			t.string 		:to_record, default: :time 		# rounds (reps), time, distance
			t.integer		:duration 						# in seconds
			t.integer 		:repeat_count, default: 0 		# use this to store rounds for time -- no need to create a segment per round. Default 8 for tabata. Default num minutes for emom
			t.integer 		:repeat_interval, default: 60 	# in seconds, so 60 for emom, 120 for eomom, 300 for every 5 mins on the minute
			t.integer 		:amrap_rep_interval, default: 0 # 0 is amrap structured via rounds / any positive number for a climbing rep scheme e.g. 3, 6, 9, 12... wld be 3
			t.integer 		:total_reps, default: 0 		# total reps in a round e.g. 30 for Cindy
			t.timestamps 
		end
		add_index :workout_segments, :workout_id

	end
end
