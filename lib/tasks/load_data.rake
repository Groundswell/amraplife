# desc "Explaining what the task does"
namespace :amraplife do

	task load_sample_data: :environment do 
		wt = Metric.where( user_id: nil ).find_by_alias( 'wt' ).try(:dup)
		wt.update( user: User.first )

		from_date = Date.new( 2017, 6, 15 )
		to_date = Date.new( 2017, 7, 18 )
		(from_date..to_date).each do |date|
			o = User.first.observations.create( observed: wt, recorded_at: date, value: rand(170..195), unit: 'lb' )
		end

		cals = Metric.where( user_id: nil ).find_by_alias( 'cal' ).try(:dup)
		cals.update( user: User.first )

		from_date = Date.new( 2017, 6, 15 )
		to_date = Date.new( 2017, 7, 18 )
		(from_date..to_date).each do |date|
			o = User.first.observations.create( observed: cals, recorded_at: date, value: rand(1700..2950), unit: 'cal' )
		end

		sleep = Metric.where( user_id: nil ).find_by_alias( 'sleep' ).try(:dup)
		sleep.update( user: User.first )

		from_date = Date.new( 2017, 6, 15 )
		to_date = Date.new( 2017, 7, 18 )
		(from_date..to_date).each do |date|
			o = User.first.observations.create( observed: sleep, recorded_at: date, value: rand(20000..36500), unit: 'sec' )
		end

	end

	task load_metrics: :environment do 
		Metric.destroy_all
		Observation.destroy_all
		UserInput.destroy_all

		puts "Adding some Metrics"
		wt = Metric.create title: 'Weight', metric_type: 'physical', aliases: ['wt', 'weigh', 'weighed'], unit: 'g', display_unit: 'kg', target_type: :value, target_direction: :at_most, target_period: :all_time
		wst = Metric.create title: 'Waist', metric_type: 'physical', aliases: ['wst'], unit: 'm', display_unit: 'cm', target_type: :value, target_direction: :at_most, target_period: :all_time
		wst = Metric.create title: 'Hips', metric_type: 'physical', aliases: ['hip'], unit: 'm', display_unit: 'cm', target_type: :value, target_direction: :at_most, target_period: :all_time
		rhr = Metric.create title: 'Resting Heart Rate', metric_type: 'physical', aliases: ['pulse', 'heart rate', 'rhr'], unit: 'bpm', target_type: :value, target_direction: :at_most, target_period: :all_time
		systolic = Metric.create title: 'Systolic Blood Pressure', metric_type: 'physical', aliases: ['sbp', 'systolic'], unit: 'mmHg', target_type: :value, target_direction: :at_most, target_period: :all_time
		diastolic = Metric.create title: 'Diastolic Blood Pressure', metric_type: 'physical', aliases: ['dbp', 'diastolic'], unit: 'mmHg', target_type: :value, target_direction: :at_most, target_period: :all_time
		bp = Metric.create title: 'Blood Pressure', metric_type: 'physical', aliases: ['bp', 'blood pressure'], unit: 'mmHg' # use sub units for sys/dias observations
		pbf = Metric.create title: 'Percent Body Fat', metric_type: 'physical', aliases: ['pbf', 'bodyfat', 'body fat'], unit: '%', target_type: :value, target_direction: :at_most, target_period: :all_time
		bmi = Metric.create title: 'Body Mass Index', metric_type: 'physical', aliases: ['bmi'], unit: 'bmi', target_type: :value, target_direction: :at_most, target_period: :all_time
		
		md = Metric.create title: 'Mood', metric_type: 'mental', aliases: [ 'feeling', 'happiness' ], unit: '%'
		md = Metric.create title: 'Energy', metric_type: 'mental', aliases: [ 'energy level' ], unit: '%'

		nutrition = Metric.create title: 'Calories', metric_type: 'nutrition', 	aliases: ['eat', 'ate', 'eating', 'eaten', 'cal', 'cals', 'meal', 'breakfast', 'lunch', 'dinner', 'snack', 'block', 'blocks'], unit: 'Cal', target_type: :sum_value, target_direction: :at_most, target_period: :daily, target: 2000
		nutrition = Metric.create title: 'Blocks', metric_type: 'nutrition', 	aliases: ['eat', 'ate', 'eating', 'meal', 'breakfast', 'lunch', 'dinner', 'snack', 'block', 'blocks'], unit: 'block', target_type: :sum_value, target_direction: :at_most, target_period: :daily, target: 15
		nutrition = Metric.create title: 'Protein', metric_type: 'nutrition',	aliases: ['prot', 'grams protein', 'grams of protein' ], unit: 'g', display_unit: 'g', target_type: :sum_value, target_direction: :at_least, target_period: :daily
		nutrition = Metric.create title: 'Fat', metric_type: 'nutrition', 		aliases: ['fat', 'grams fat', 'grams of fat' ], unit: 'g', display_unit: 'g', target_type: :sum_value, target_direction: :at_most, target_period: :daily
		nutrition = Metric.create title: 'Carb', metric_type: 'nutrition', 		aliases: ['carb', 'carbs', 'carbohydrates', 'grams carb', 'grams of carb', 'net carbs' ], unit: 'g', display_unit: 'g', target_type: :sum_value, target_direction: :at_most, target_period: :daily
		nutrition = Metric.create title: 'Sugar', metric_type: 'nutrition', 	aliases: ['sugars', 'grams sugar', 'grams of sugar' ], unit: 'g', target_type: :sum_value, target_direction: :at_most, target_period: :daily
		nutrition = Metric.create title: 'Water', metric_type: 'nutrition', 	aliases: ['of water' ], unit: 'l', display_unit: 'ml', target_type: :sum_value, target_direction: :at_least, target_period: :daily
		nutrition = Metric.create title: 'Alcohol', metric_type: 'nutrition', 	aliases: [ 'of alcohol', 'beer', 'wine', 'liquor' ], unit: 'l', display_unit: 'ml', target_type: :sum_value, target_direction: :at_most, target_period: :daily

		act = Metric.create title: 'Sleep', metric_type: 'activity', 	aliases: ['slp', 'sleeping', 'slept', 'nap', 'napping', 'napped'], unit: 's', target_type: :sum_value, target_direction: :at_least, target_period: :daily, target: 28800
		act = Metric.create title: 'Meditation', metric_type: 'activity', aliases: ['med', 'meditating', 'meditated'], unit: 's', target_type: :sum_value, target_direction: :at_least, target_period: :daily, target: 1200
		act = Metric.create title: 'Drive', metric_type: 'activity', 	aliases: ['drv', 'driving', 'drove'], unit: 's'
		act = Metric.create title: 'Work', metric_type: 'activity', 	aliases: ['wrk', 'working', 'worked'], unit: 's'
		act = Metric.create title: 'Walk', metric_type: 'activity', 	aliases: ['wlk', 'walking', 'walked'], unit: 's'
		act = Metric.create title: 'Cycle', metric_type: 'activity', aliases: ['cycling', 'cycled', 'bike', 'biked', 'biking', 'bicycling', 'bicycled', 'bicycle' ], unit: 's'
		act = Metric.create title: 'Swim', metric_type: 'activity', aliases: ['swimming', 'swam'], unit: 's'
		act = Metric.create title: 'Run', metric_type: 'activity', aliases: ['running', 'ran', 'jog', 'jogging', 'jogged'], unit: 's'

		bmi = Metric.create title: 'Workout', metric_type: 'activity', aliases: ['wkout', 'worked out', 'exercise', 'exercised'], unit: 's'
		# workouts must have time... record scores, reps, etc as sub observations.
		# bmi = Metric.create title: 'AMRAP', metric_type: 'activity', aliases: ['amrap'], unit: 'rep'

		act = Metric.create title: 'Max Bench', metric_type: 'benchmark', aliases: ['bench', 'bench press'], unit: 'g', display_unit: 'kg', target_type: :value, target_direction: :at_least, target_period: :all_time
		act = Metric.create title: 'Max Deadlift', metric_type: 'benchmark', aliases: ['deadlift', 'dl', 'dead lift'], unit: 'g', display_unit: 'kg', target_type: :value, target_direction: :at_least, target_period: :all_time
		act = Metric.create title: 'Max Backsquat', metric_type: 'benchmark', aliases: ['squat', 'back squat'], unit: 'g', display_unit: 'kg', target_type: :value, target_direction: :at_least, target_period: :all_time
		act = Metric.create title: 'Max Press', metric_type: 'benchmark', aliases: ['press'], unit: 'g', display_unit: 'kg', target_type: :value, target_direction: :at_least, target_period: :all_time
		act = Metric.create title: 'Max Clean', metric_type: 'benchmark', aliases: ['clean', 'power clean'], unit: 'g', display_unit: 'kg', target_type: :value, target_direction: :at_least, target_period: :all_time
		act = Metric.create title: 'Max Clean & Jerk', metric_type: 'benchmark', aliases: ['clean n jerk', 'clean and jerk', 'clean jerk'], unit: 'g', display_unit: 'kg', target_type: :value, target_direction: :at_least, target_period: :all_time
		act = Metric.create title: 'Max Snatch', metric_type: 'benchmark', aliases: ['snatch'], unit: 'g', display_unit: 'kg', target_type: :value, target_direction: :at_least, target_period: :all_time
		act = Metric.create title: '100m Time', metric_type: 'benchmark', aliases: ['hundred', 'one hundred', 'hundred time', 'hundred meter time', 'hundred meter'], unit: 's', target_type: :value, target_direction: :at_most, target_period: :all_time
		act = Metric.create title: '400m Time', metric_type: 'benchmark', aliases: ['four_hundred'], unit: 's', target_type: :value, target_direction: :at_most, target_period: :all_time
		act = Metric.create title: 'Mile Time', metric_type: 'benchmark', aliases: ['mile', 'one mile'], unit: 's', target_type: :value, target_direction: :at_most, target_period: :all_time
		# act = Metric.create title: 'Max Pushups', metric_type: 'benchmark', aliases: ['pushups'], unit: 'rep', target_type: :value, target_direction: :at_least, target_period: :all_time
		# act = Metric.create title: 'Max Pullups', metric_type: 'benchmark', aliases: ['pullups'], unit: 'rep', target_type: :value, target_direction: :at_least, target_period: :all_time
		# act = Metric.create title: 'Max Burpees', metric_type: 'benchmark', aliases: ['burpees'], unit: 'rep', target_type: :value, target_direction: :at_least, target_period: :all_time
		# act = Metric.create title: 'Max Situps', metric_type: 'benchmark', aliases: ['burpees'], unit: 'rep', target_type: :value, target_direction: :at_least, target_period: :all_time


	end

	task load_elasticsearch: :environment do

		puts Product.__elasticsearch__.client.indices.delete index: Product.index_name rescue nil

		puts SwellEcom::Product.__elasticsearch__.client.indices.create \
			index: SwellEcom::Product.index_name,
			body: { settings: SwellEcom::Product.settings.to_hash, mappings: SwellEcom::Product.mappings.to_hash }


		Product.all.find_each( batch_size: 500 ) do |product|

			begin
				product.__elasticsearch__.index_document #if self.published?
			rescue Exception => e
				NewRelic::Agent.notice_error(e) if defined? NewRelic::Agent
				puts e
			end

		end

		puts Place.__elasticsearch__.client.indices.delete index: Place.index_name rescue nil

		puts Place.__elasticsearch__.client.indices.create \
			index: Place.index_name,
			body: { settings: Place.settings.to_hash, mappings: Place.mappings.to_hash }


		Place.all.find_each( batch_size: 500 ) do |place|

			begin
				place.__elasticsearch__.index_document #if self.published?
			rescue Exception => e
				NewRelic::Agent.notice_error(e) if defined? NewRelic::Agent
				puts e
			end

		end

	end

	task load_products: :environment do


		product = SwellEcom::Product.create title: 'HSPU AMARAP T-Shirt', slug: 'hspuamrap-tshirt', avatar: 'http://cdn1.amraplife.com/assets/8ff15d00-9102-49b5-972f-db9a7d66c3af.png'
		product.product_options.create label: "Size", code: 'size'

		product.skus.create code: 'hspuamrap-tshirt-sm',  price: 2800, label: 'Small', name: 'HSPU AMRAP T-Shirt, Small', options: { size: 'Small' }, status: 'active', avatar: 'http://cdn1.amraplife.com/assets/8ff15d00-9102-49b5-972f-db9a7d66c3af.png'
		product.skus.create code: 'hspuamrap-tshirt-md',  price: 2800, label: 'Medium', name: 'HSPU AMRAP T-Shirt, Medium', options: { size: 'Medium' }, status: 'active', avatar: 'http://cdn1.amraplife.com/assets/8ff15d00-9102-49b5-972f-db9a7d66c3af.png'
		product.skus.create code: 'hspuamrap-tshirt-lg',  price: 2800, label: 'Large', name: 'HSPU AMRAP T-Shirt, Large', options: { size: 'Large' }, status: 'active', avatar: 'http://cdn1.amraplife.com/assets/8ff15d00-9102-49b5-972f-db9a7d66c3af.png'
		product.skus.create code: 'hspuamrap-tshirt-xlg', price: 2800, label: 'Extra Large', name: 'HSPU AMRAP T-Shirt, Extra Large', options: { size: 'Extra Large' }, status: 'active', avatar: 'http://cdn1.amraplife.com/assets/8ff15d00-9102-49b5-972f-db9a7d66c3af.png'


	end

	task load_data: :environment do
		puts "Loading Data"

		

		puts "Adding some Equipment"
		am = Equipment.create title: 'Ab Mat', aliases: ['ab']
		rope = Equipment.create title: 'Climbing Rope', aliases: ['rope']
		pub = Equipment.create title: 'Pullup Bar', aliases: ['bar']
		box = Equipment.create title: "Plyo Box", unit_type: 'inch', aliases: ['box']
		rings = Equipment.create title: 'Rings', aliases: ['rng']
		jr = Equipment.create title: 'Jump Rope', aliases: ['jr']
		rower = Equipment.create title: 'Rower', aliases: ['row', 'c2']
		ghd = Equipment.create title: 'Glute Ham Developer', aliases: ['ghd']
		band = Equipment.create title: 'Resistance Band', aliases: ['band']
		vest = Equipment.create title: 'Weighted Vest', aliases: ['vest']
		kb = Equipment.create title: 'Kettle Bell', aliases: ['kb']
		bb = Equipment.create title: 'Bar Bell', unit_type: 'lb', unit: 45, aliases: ['bb']
		db = Equipment.create title: 'Dumb Bell', aliases: ['db']
		mb = Equipment.create title: 'Medicine Ball', aliases: ['mb']
		sb = Equipment.create title: 'Slam Ball', aliases: ['sb']
		paras = Equipment.create title: 'Parallettes', aliases: ['para']
		tire = Equipment.create title: 'Tire', aliases: ['tire']

		puts "Adding Movements"
		run = Movement.create title: 'Run', measured_by: :distance, 	aliases: [ 'run', 'rn', 'running' ]
		backrun = Movement.create title: 'Backwards Run', measured_by: :distance, 	aliases: [ 'brun', 'brn' ]
		sdrun = Movement.create title: 'Sideways Run', measured_by: :distance, 	aliases: [ 'siderun', 'sdrn' ]
		krkrun = Movement.create title: 'Karaoke Run', measured_by: :distance, 	aliases: [ 'karaoke', 'krkrun' ]
		sprint = Movement.create title: 'Sprint', measured_by: :distance, aliases: [ 'sp', 'spr', 'sprint', 'spnt' ]
		carry = Movement.create title: 'Carry', measured_by: :distance, aliases: [ 'cry' ], description: 'Aside from Farmer Carry and Buddy Carry, a generic carry task. May have to carry medicine balls, sandbags, plates, who knows.'
		row = Movement.create title: 'Row', measured_by: :distance, equipment_id: rower.id, aliases: [ 'rowing', 'rower', 'rw' ]
		pushup = Movement.create title: 'Pushup', aliases: [ 'psu', 'push', 'pushup', 'pup' ]
		pushup = Movement.create title: 'Decline Pushup', aliases: [ 'dpsu', 'dpush', 'dpushup', 'dpup' ]
		pushup = Movement.create title: 'Hand Release Pushup', aliases: [ 'hrpu', 'hrpush', 'hrpup' ]
		pushup = Movement.create title: 'Diamond Pushup', aliases: [ 'dpu', 'dpush', 'dpup' ]
		pullup = Movement.create title: 'Pullup', equipment_id: pub.id, aliases: [ 'pu', 'pull', 'pull up' ]
		jumping_pullup = Movement.create title: 'Jumping Pullup', equipment_id: pub.id, aliases: [ 'jpu', 'jump pu', 'jumping pu', 'jump pull', 'jmpu' ]
		l_pullup = Movement.create title: 'L-Pullup', equipment_id: pub.id, aliases: [ 'lpu', 'lpull', 'lpullup' ]
		chin = Movement.create title: 'Chinup', equipment_id: pub.id, aliases: [ 'chin', 'chn', 'chinup' ]
		ctb = Movement.create title: 'Chest to Bar Pullup', equipment_id: pub.id, aliases: [ 'ctb', 'c2b', 'chest to bar' ]
		ttb = Movement.create title: 'Toe to Bar', equipment_id: pub.id, aliases: [ 'ttb', 't2b', 'toe2bar' ]
		kte = Movement.create title: 'Knee to Elbow', equipment_id: pub.id, aliases: [ 'kte', 'k2e' ]
		rope = Movement.create title: 'Rope Climb', equipment_id: rope.id, aliases: [ 'rp', 'rpc', 'rope' ]
		ll_rope = Movement.create title: 'Legless Rope Climb', equipment_id: rope.id, aliases: [ 'llrc', 'llrpc' ]
		abmat = Movement.create title: 'Abmat Situp', equipment_id: am.id, aliases: [ 'absu', 'abmat', 'abmatsu' ]
		ghd_situp = Movement.create title: 'GHD Situp', equipment_id: ghd.id, aliases: [ 'ghd', 'ghdsu' ]
		hspu = Movement.create title: 'Handstand Pushup', aliases: [ 'hspu' ]
		hh = Movement.create title: 'Handstand Hold', measured_by: :time, aliases: [ 'hh', 'handhold', 'hsh' ]
		hsw = Movement.create title: 'Handstand Walk', measured_by: :distance, aliases: [ 'hsw', 'hw' ]
		du = Movement.create title: 'Double Under', equipment_id: jr.id, aliases: [ 'du', 'dus', 'double-under' ]
		su = Movement.create title: 'Single Under', equipment_id: jr.id, parent_id: du, aliases: [ 'su', 'sus', 'single-under' ]
		boxjump = Movement.create title: 'Box Jump', equipment_id: box.id, aliases: [ 'bj', 'box', 'boxjump', 'bxj' ]
		boxjump = Movement.create title: 'Box Step Up', equipment_id: box.id, aliases: [ 'bxsu', 'stepup', 'boxstep' ]
		boxjump = Movement.create title: 'Box Jumpover', equipment_id: box.id, aliases: [ 'bjo', 'boxo', 'boxjpo' ]
		plank = Movement.create title: 'Plank Hold', measured_by: :time, aliases: [ 'plk', 'plank' ]
		plank = Movement.create title: 'Pike Leg Lift', aliases: [ 'pll', 'seatedpikell' ]
		airsquat = Movement.create title: 'Air Squat', aliases: [ 'squat', 'asq', 'sq' ]
		airsquat = Movement.create title: 'Jumping Squat', aliases: [ 'jsq', 'jump squat' ]
		burpee = Movement.create title: 'Burpee', aliases: [ 'brp', 'burp' ]
		burpee = Movement.create title: 'Candlestick', aliases: [ 'cs', 'cndlstk' ]
		otbb = Movement.create title: 'Over the Bar Burpee', equipment_id: bb.id, aliases: [ 'otbb', 'overbarburpee' ]
		bfb = Movement.create title: 'Bar Facing Burpee', equipment_id: bb.id, aliases: [ 'bfb' ]
		otbb = Movement.create title: 'Burpee Pullup', equipment_id: pub.id, aliases: [ 'brppull', 'brpull', 'brppu', 'brpu' ]
		kbs = Movement.create title: 'Kettlebell Swing', equipment_id: kb.id, aliases: [ 'kbs', 'kb swing' ]
		lunge = Movement.create title: 'Lunge', aliases: [ 'lng' ]
		rev_lunge = Movement.create title: 'Reverse Lunge', aliases: [ 'revlng' ]
		waking_lunge = Movement.create title: 'Walking Lunge', aliases: [ 'wlng' ]
		waking_lunge = Movement.create title: 'Overhead Walking Lunge', aliases: [ 'ohwlng' ]
		waking_lunge = Movement.create title: 'Jumping Lunge', aliases: [ 'jlng' ]
		hr = Movement.create title: 'Hollow Rock', aliases: [ 'hr', 'rock', 'hollowrock' ]
		superman = Movement.create title: 'Superman', aliases: [ 'sup' ]
		mc = Movement.create title: 'Mountain Climber', aliases: [ 'mc', 'mtclimber' ]
		rd = Movement.create title: 'Ring Dip', equipment_id: rings.id, aliases: [ 'rdip', 'rd', 'dip' ]
		rd = Movement.create title: 'Bench Dip', aliases: [ 'bdip', 'bd', 'bnchdip' ]
		fc = Movement.create title: 'Farmer Carry', aliases: [ 'fc', 'farmer' ]
		wb = Movement.create title: 'Wall Ball', equipment_id: mb.id, aliases: [ 'wb', 'wallball', 'wallballshot' ]
		sb = Movement.create title: 'Slam Ball', equipment_id: sb.id, aliases: [ 'sb', 'ballslam' ]
		vu = Movement.create title: 'V Up', aliases: [ 'vu' ]
		vu = Movement.create title: 'Bear Crawl', aliases: [ 'bc', 'brcwl' ]
		vu = Movement.create title: 'Inch Worm', aliases: [ 'iwrm', 'inwrm' ]
		vu = Movement.create title: 'Broad Jump', aliases: [ 'bjmp', 'bdjp' ]
		vu = Movement.create title: 'Burpee Broad Jump', aliases: [ 'bpbdjp' ]
		vu = Movement.create title: 'Burpee Box Jump', aliases: [ 'bpbxjp' ]
		vu = Movement.create title: 'Slam Ball Burpee', equipment_id: sb.id, aliases: [ 'sbb' ]
		vu = Movement.create title: 'Jumping Jack', aliases: [ 'jj', 'jacks' ]
		vu = Movement.create title: 'Skater', aliases: [ 'skt', 'sk8', 'sktr' ]
		vu = Movement.create title: 'High Knee', aliases: [ 'hknee' ]
		vu = Movement.create title: 'Flutter Kicks', aliases: [ 'fk' ]
		vu = Movement.create title: 'Butt Kicker', aliases: [ 'bkick' ]
		vu = Movement.create title: 'Duck Walk', aliases: [ 'dwlk' ]
		vu = Movement.create title: 'L Sit', aliases: [ 'ls', 'lst' ], equipment_id: paras.id
		vu = Movement.create title: 'Wall Sit', aliases: [ 'wls', 'wlst' ]
		vu = Movement.create title: 'Calf Raise', aliases: [ 'crs', 'cr' ]
		vu = Movement.create title: 'Single Leg Calf Raise', aliases: [ 'scrs', 'scr', 'slcr' ]
		vu = Movement.create title: 'Bicycle Situp', aliases: [ 'bsu', 'bicycle' ]
		vu = Movement.create title: 'Russian Twist', aliases: [ 'rtw' ]
		vu = Movement.create title: 'Tuck Jump', aliases: [ 'tjmp' ]
		vu = Movement.create title: 'Wall Walk', aliases: [ 'ww' ]
		vu = Movement.create title: 'Atomic Situp', aliases: [ 'asu' ]
		vu = Movement.create title: 'Ski Hop', aliases: [ 'ski', 'skih', 'skijump' ]
		vu = Movement.create title: 'Buddy Carry', aliases: [ 'budc', 'bdycr' ]
		vu = Movement.create title: 'Reverse Plank', measured_by: :time, aliases: [ 'rplk', 'rplank', 'revplk' ]
		vu = Movement.create title: 'Tire Flip', equipment_id: tire.id, aliases: [ 'tflp', 'tflip' ]
		vu = Movement.create title: 'Rope Pulls', aliases: [ 'rpls' ], equipment_id: rope.id, description: 'Scaled rope climb'
		vu = Movement.create title: 'Back Extension', aliases: [ 'be', 'bex' ], equipment_id: ghd.id

		# lifting
		bs = Movement.create title: 'Back Squat', equipment_id: bb.id, aliases: [ 'bs', 'bsq', 'backsq' ]
		fs = Movement.create title: 'Front Squat', equipment_id: bb.id, aliases: [ 'fs', 'fsq', 'frontsq' ]
		m = Movement.create title: 'Pistol Squat', aliases: [ 'pst', 'pstl', 'psq' ]
		m = Movement.create title: 'Monkey Squat', aliases: [ 'mnkysq', 'monkeysq' ]
		ohs = Movement.create title: 'Overhead Squat', equipment_id: bb.id, aliases: [ 'ohs', 'ohsq', 'osq' ]
		m = Movement.create title: 'Overhead Lunge', equipment_id: bb.id, aliases: [ 'olng', 'ohlng', 'ohl' ]
		m = Movement.create title: 'Front-Rack Lunge', equipment_id: bb.id, aliases: [ 'frlng', 'frl', 'flng' ]
		sn = Movement.create title: 'Snatch', equipment_id: bb.id, aliases: [ 'sn', 'sntch', 'snch' ]
		ps = Movement.create title: 'Power Snatch', parent_id: sn.id, equipment_id: bb.id, aliases: [ 'psn', 'psntch', 'psnch', 'pwrsn' ]
		hps = Movement.create title: 'Hang Power Snatch', parent_id: sn.id, equipment_id: bb.id, aliases: [ 'hpsn', 'hpsntch', 'hngpsn', 'hngpwrsn' ]
		gto = Movement.create title: 'Ground to Overhead', equipment_id: bb.id, aliases: [ 'gto', 'g2o', 'gndtoh' ]
		dl = Movement.create title: 'Deadlift', equipment_id: bb.id, aliases: [ 'dl', 'dlft', 'ddl' ]
		thruster = Movement.create title: 'Thruster', equipment_id: bb.id, aliases: [ 'thr', 'thrst', 'thrstr' ]
		db_thruster = Movement.create title: 'Dumbell Thruster', parent_id: thruster.id, equipment_id: db.id, aliases: [ 'dbthr', 'dbthrst', 'dbthrstr' ]
		db_thruster = Movement.create title: 'Man Maker', equipment_id: db.id, aliases: [ 'mm', 'mmkr', 'manmkr' ]
		db_thruster = Movement.create title: 'Renegade Row', equipment_id: db.id, aliases: [ 'rr' ]
		clu = Movement.create title: 'Cluster', equipment_id: bb.id, description: 'Squat Clean Thruster', aliases: [ 'clst', 'clstr', 'sqclnthr' ]
		cln = Movement.create title: 'Clean', equipment_id: bb.id, aliases: [ 'cl', 'cln' ]
		cln = Movement.create title: 'Medicine Ball Clean', equipment_id: mb.id, aliases: [ 'mbcl', 'mbcln' ]
		pc = Movement.create title: 'Power Clean', parent_id: cln.id, equipment_id: bb.id, aliases: [ 'pc', 'pwrcl', 'pcl', 'pcln', 'pwrcln' ]
		hpc = Movement.create title: 'Hang Power Clean', parent_id: cln.id, equipment_id: bb.id, aliases: [ 'hpc', 'hpcl', 'hpcln' ]
		hpc = Movement.create title: 'Hang Squat Clean', parent_id: cln.id, equipment_id: bb.id, aliases: [ 'hsc', 'hsqcl', 'hscln' ]
		sqc = Movement.create title: 'Squat Clean', parent_id: cln.id, equipment_id: bb.id, aliases: [ 'sqc', 'sqcl', 'sqcln' ]
		cj = Movement.create title: 'Clean & Jerk', equipment_id: bb.id, aliases: [ 'cj', 'c&j', 'clnjrk', 'cln&jrk' ]
		bp = Movement.create title: 'Bench Press', aliases: [ 'bp', 'bench', 'bpress' ], equipment_id: bb.id
		press = Movement.create title: 'Press', equipment_id: bb.id, aliases: [ 'ps' ]
		s2o = Movement.create title: 'Shoulder to Overhead', equipment_id: bb.id, aliases: [ 's2o', 'sto' ]
		m = Movement.create title: 'Good Morning', equipment_id: bb.id, aliases: [ 'gm' ]
		m = Movement.create title: 'Single Led Deadlift', equipment_id: kb.id, aliases: [ 'sldl' ]
		m = Movement.create title: 'Sumo Deadlift', equipment_id: bb.id, aliases: [ 'sumodl' ]
		m = Movement.create title: 'Romainian Deadlift', equipment_id: bb.id, aliases: [ 'rdl', 'rmdl' ]
		m = Movement.create title: 'Bulgarian Split Squat', equipment_id: bb.id, aliases: [ 'bspsq', 'bssq' ]
		m = Movement.create title: 'Military Press', equipment_id: bb.id, aliases: [ 'mp', 'milps' ]
		pp = Movement.create title: 'Push Press', equipment_id: bb.id, aliases: [ 'pp', 'pshps' ]
		pj = Movement.create title: 'Push Jerk', equipment_id: bb.id, aliases: [ 'pj', 'pshjrk' ]
		pj = Movement.create title: 'Split Jerk', equipment_id: bb.id, aliases: [ 'sj', 'sjrk', 'spjk' ]
		sdhp = Movement.create title: 'Sumo Deadlift High Pull', equipment_id: bb.id, aliases: [ 'sdhp', 'sumo' ]
		sdhp = Movement.create title: 'Windshield Wiper', equipment_id: bb.id, aliases: [ 'wiper', 'wsw' ]
		sdhp = Movement.create title: 'Ab Rollout', equipment_id: bb.id, aliases: [ 'ro', 'bbro' ]
		tgu = Movement.create title: 'Turkish Get Up', equipment_id: kb.id, aliases: [ 'tgu' ]
		mu = Movement.create title: 'Muscle Up', equipment_id: rings.id, aliases: [ 'mu' ]
		rr = Movement.create title: 'Ring Row', equipment_id: rings.id, aliases: [ 'rr', 'rngrow' ]
		ring_push = Movement.create title: 'Ring Pushup', equipment_id: rings.id, aliases: [ 'rp', 'rpsu', 'rpup' ]
		ring_push = Movement.create title: 'Ring Handstand Pushup', equipment_id: rings.id, aliases: [ 'rhsp', 'rhspsu', 'rhspup' ]
		bmu = Movement.create title: 'Bar Muscle Up', equipment_id: pub.id, aliases: [ 'bmu' ]
		uprow = Movement.create title: 'Upright Row', equipment_id: bb.id, aliases: [ 'uprow', 'urow' ]
		uprow = Movement.create title: 'Curl', equipment_id: db.id, aliases: [ 'bicep', 'bcurl', 'crl' ]
	end

	task load_test_workouts: :environment do
		puts "Adding some test workouts"

		cindy = Workout.create title: 'Cindy', cover_image: "http://cooeecrossfit.com.au/wp-content/uploads/2013/05/WOD_Cindy.jpg"
		cindy.workout_segments.create content: "5 pullups\r\n10 push ups\r\n15 air squats", segment_type: :amrap, duration: 20 # 20*60

		murph = Workout.create title: 'Murph (Straight)', cover_image: 'http://crossfitlakeland.com/wp-content/uploads/2014/05/murph-wod4-630x630.jpg'
		murph.workout_segments.create content: "run 1 mile", segment_type: :ft, seq: 1
		murph.workout_segments.create content: "100 pullups", segment_type: :ft, seq: 2
		murph.workout_segments.create content: "200 pushups", segment_type: :ft, seq: 3
		murph.workout_segments.create content: "300 air squats", segment_type: :ft, seq: 4
		murph.workout_segments.create content: "run 1 mile", segment_type: :ft, seq: 5

		fran = Workout.create title: 'Fran', cover_image: "https://cdn2.omidoo.com/sites/default/files/imagecache/full_width/images/bydate/201503/crossfitempirical142.jpg"
		fran.workout_segments.create content: "21 15 9\r\nThrusters @ 95/65\r\nPullups", segment_type: :ft

		glen = Workout.create title: 'Glen', cover_image: "http://www.crossfitnyc.com/wp-content/uploads/2013/12/glenincountry.jpg"
		glen.workout_segments.create content: "30 GTO @135lbs/95lbs", segment_type: 'ft', seq: 1
		glen.workout_segments.create content: "Run 1 mile", segment_type: 'ft', seq: 2
		glen.workout_segments.create content: "10 Rope Climbs", segment_type: 'ft', seq: 3
		glen.workout_segments.create content: "Run 1 mile", segment_type: 'ft', seq: 4
		glen.workout_segments.create content: "100 Burpees", segment_type: 'ft', seq: 5

		helen = Workout.create title: 'Helen', cover_image: "https://d1s2fu91rxnpt4.cloudfront.net/legacy/Helen1.jpg"
		helen.workout_segments.create content: "Run 400m\r\n21 kettlbell swings\r\n12 pullups", segment_type: :rft, repeat_count: 3

		accumulate = Workout.create title: 'Test Accumulate'
		accumulate.workout_segments.create content: "Plank Hold; accumulate 1 minute", segment_type: :accumulate, duration: 60

		emom = Workout.create title: 'Test EMOM'
		emom.workout_segments.create content: "1 high hang squat clean\r\n1 squat clean from above knee\r\n1 squat clean @ 2/3 body-weight", segment_type: :emom, repeat_count: 5, repeat_interval: 10

		emom = Workout.create title: 'Test Tabata'
		emom.workout_segments.create content: "DB bent rows", segment_type: :tabata, repeat_count: 8, repeat_interval: 30

		strength = Workout.create title: 'Test Strength'
		strength.workout_segments.create content: "Find 2RM DL", segment_type: :strength

	end

	task load_terms: :environment do
		html_data = open('https://amraplife.com/crossfit-terms').read
		nokogiri_doc = Nokogiri::HTML(html_data)
		term_blocks = nokogiri_doc.css("ul.crossfit-terms > li")
		term_blocks.each do |entry|
			content = entry.text.gsub( /\n/, '' ).gsub( /(^.+:)/, '' )

			terms = entry.css("strong")
			title = terms[0].text.gsub( /:/, '' ).gsub( /\(|\)/, '' ).strip
			if Term.pluck( :title ).include?( title )
				puts "--------- Skipping #{title}"
				next
			end
			aliases_csv = ''
			aliases_csv = terms[1].text.gsub( /aka/, '' ).strip unless terms[1].nil?

			t=Term.create( title: title, aliases_csv: aliases_csv, content: content )
			puts "Created #{t.title}"
		end
	end
end
