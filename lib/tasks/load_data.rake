# desc "Explaining what the task does"
namespace :amraplife do

	task load_users: :environment do
		10.times{
			name = PasswordGeneratorService.new.generate( length: 4 )
			domain = PasswordGeneratorService.new.generate( length: 6 )
			pw = PasswordGeneratorService.new.generate()
			u = User.create email: "#{name}@#{domain}.com", password: pw 
			puts "Created user: #{u.nickname} - #{u.email} - #{pw}"
		}
	end


	task load_sample_data: :environment do

		5.times{
			u = User.create name: ('a'..'z').to_a.concat(('A'..'Z').to_a).shuffle[0,8].join, password: '1234', email: ('a'..'z').to_a.shuffle[0,3].join + "@amrap.com"
		}

		wt = Metric.where( user_id: nil ).find_by_alias( 'wt' ).try(:dup)
		u = Unit.pound
		wt.update( user: User.first, unit: u )

		from_date = Date.new( 2017, 6, 15 )
		to_date = Time.zone.now 
		
		(from_date..to_date).each do |date|
			o = User.first.observations.create( observed: wt, recorded_at: date, value: u.convert_to_base( rand(170..195)), unit: u )
		end

		cals = Metric.where( user_id: nil ).find_by_alias( 'cal' ).try(:dup)
		cals.update( user: User.first )

		from_date = Date.new( 2017, 6, 15 )
		to_date = Time.zone.now
		(from_date..to_date).each do |date|
			o = User.first.observations.create( observed: cals, recorded_at: date, value: rand(1700..2950), unit: Unit.calorie )
		end

		sleep = Metric.where( user_id: nil ).find_by_alias( 'sleep' ).try(:dup)
		sleep.update( user: User.first )

		from_date = Date.new( 2017, 6, 15 )
		to_date =  Time.zone.now
		(from_date..to_date).each do |date|
			o = User.first.observations.create( observed: sleep, recorded_at: date, value: rand(20000..36500), unit: Unit.sec )
		end

	end

	task load_metrics: :environment do
		Metric.destroy_all
		Observation.destroy_all
		UserInput.destroy_all
		Target.destroy_all
		Unit.destroy_all

		User.update_all use_imperial_units: true

		puts "Adding some Units"

		none = Unit.create name: 'None', unit_type: 'nada'

		score = Unit.create name: 'Score', unit_type: 'custom'

		bpm = Unit.create name: 'BPM', abbrev: 'bpm', aliases: ['heart rate'], unit_type: 'rate'

		mgdl = Unit.create name: 'mg/dL', abbrev: 'mg/dL', aliases: ['mgdL'], unit_type: 'custom'
		mmoll = Unit.create name: 'mmol/L', abbrev: 'mmol/L', aliases: ['mmolL'], unit_type: 'custom', base_unit: mgdl, conversion_factor: 18
		
		bmi = Unit.create name: 'Bodymass Index', abbrev: 'bmi', unit_type: 'custom'
		block = Unit.create name: 'Block', abbrev: 'block', unit_type: 'custom'

		round = Unit.create name: 'Round', abbrev: 'rd', unit_type: 'custom'
		rep = Unit.create name: 'Rep', abbrev: 'rep', unit_type: 'custom'

		celcius = Unit.create name: 'Degrees Celcius', abbrev: 'celcius', aliases: ['c', 'cel'], unit_type: 'temperature', imperial: false
		f = Unit.create name: 'Degrees Farenheit', abbrev: 'degrees', aliases: ['f', 'degs'], unit_type: 'temperature', base_unit: celcius, conversion_factor: 5/9.to_f
		celcius.update( imperial_correlate_id: f.id )

		per = Unit.create name: 'Percent', abbrev: '%', unit_type: 'percent'

		mmhg = Unit.create name: 'Millimeters Mercury', abbrev: 'mmHg', aliases: ['mmhg'], unit_type: 'pressure'
		psi = Unit.create name: 'Pounds Per Square Inch', abbrev: 'psi', unit_type: 'pressure'

		cal = Unit.create name: 'Calorie', abbrev: 'cal', aliases: ['kCal', 'calory'], unit_type: 'energy'
		jl = Unit.create name: 'Joule', abbrev: 'j', unit_type: 'energy', base_unit: cal, conversion_factor: 0.239006

		g = Unit.create name: 'Gram', abbrev: 'g', unit_type: 'weight', imperial: false
		kg = Unit.create name: 'Kilogram', abbrev: 'kg', aliases: ['kilo'], unit_type: 'weight', base_unit: g, conversion_factor: 1000, imperial: false
		lb = Unit.create name: 'Pound', abbrev: 'lb', aliases: ['#'], unit_type: 'weight', base_unit: g, conversion_factor: 453.592
		oz = Unit.create name: 'Ounce', abbrev: 'oz', aliases: ['oz'], unit_type: 'weight', base_unit: g, conversion_factor: 28.3495
		g.update( imperial_correlate_id: oz.id )
		kg.update( imperial_correlate_id: lb.id )

		m = Unit.create name: 'Meter', abbrev: 'm', unit_type: 'length', imperial: false
		cm = Unit.create name: 'Centimeter', abbrev: 'cm', unit_type: 'length', base_unit: m, conversion_factor: 0.01, imperial: false
		mm = Unit.create name: 'Millimeter', abbrev: 'mm', unit_type: 'length', base_unit: m, conversion_factor: 0.001, imperial: false
		km = Unit.create name: 'Kilometer', abbrev: 'km', aliases: [ 'k' ], unit_type: 'length', base_unit: m, conversion_factor: 1000, imperial: false
		inch = Unit.create name: 'Inch', abbrev: 'in', unit_type: 'length', aliases: ['"'], base_unit: m, conversion_factor: 0.0254
		ft = Unit.create name: 'Foot', abbrev: 'ft', unit_type: 'length', aliases: ["'"], base_unit: m, conversion_factor: 0.3048
		yd = Unit.create name: 'Yard', abbrev: 'yd', unit_type: 'length', base_unit: m, conversion_factor: 0.9144
		mi = Unit.create name: 'Mile', abbrev: 'mi', unit_type: 'length', base_unit: m, conversion_factor: 1609.34
		m.update( imperial_correlate_id: yd.id )
		cm.update( imperial_correlate_id: inch.id )
		mm.update( imperial_correlate_id: inch.id )
		km.update( imperial_correlate_id: mi.id )

		l = Unit.create name: 'Liter', abbrev: 'l', unit_type: 'volume', imperial: false
		ml = Unit.create name: 'Milliliter', abbrev: 'ml', unit_type: 'volume', base_unit: l, conversion_factor: 0.001, imperial: false
		cup = Unit.create name: 'Cup', abbrev: 'cup', unit_type: 'volume', base_unit: l, conversion_factor: 0.24
		gal = Unit.create name: 'Gallon', abbrev: 'gal', unit_type: 'volume', base_unit: l, conversion_factor: 3.78541
		qt = Unit.create name: 'Quart', abbrev: 'qt', unit_type: 'volume', base_unit: l, conversion_factor: 0.946352499983857
		pt = Unit.create name: 'Pint', abbrev: 'pt', unit_type: 'volume', base_unit: l, conversion_factor: 0.47317624999192847701
		floz = Unit.create name: 'Fluid Ounce', abbrev: 'fl oz', unit_type: 'volume', base_unit: l, conversion_factor: 0.0295735
		l.update( imperial_correlate_id: gal.id )
		ml.update( imperial_correlate_id: floz.id )

		sec = Unit.create name: 'Second', abbrev: 's', aliases: ['time'], unit_type: 'time'
		min = Unit.create name: 'Minute', abbrev: 'min', unit_type: 'time', base_unit: sec, conversion_factor: 60
		hr = Unit.create name: 'Hour', abbrev: 'hr', unit_type: 'time', base_unit: sec, conversion_factor: 3600
		day = Unit.create name: 'Day', abbrev: 'day', unit_type: 'time', base_unit: sec, conversion_factor: 86400
		

		puts "Adding some Metrics"
		wt = Metric.create title: 'Weight', default_value_type: 'current_value', aliases: ['wt', 'weigh', 'weighed', 'wait'], unit: kg
		wt.targets.create target_type: :current_value, direction: :at_most, period: :all_time

		wst = Metric.create title: 'Waist', default_value_type: 'current_value', aliases: ['wst'], unit: cm
		wst.targets.create target_type: :current_value, direction: :at_most, period: :all_time

		hps = Metric.create title: 'Hips', default_value_type: 'current_value', aliases: ['hip'], unit: cm
		hps.targets.create target_type: :current_value, direction: :at_most, period: :all_time

		rhr = Metric.create title: 'Resting Heart Rate', default_value_type: 'current_value', aliases: ['pulse', 'heart rate', 'rhr'], unit: bpm
		rhr.targets.create target_type: :current_value, direction: :at_most, period: :all_time

		
		systolic = Metric.create title: 'Blood Pressure', default_value_type: 'current_value', aliases: ['sbp', 'systolic', 'blood pressure'], unit: mmhg # blood pressure is a compund with a sub. By default, systolic is first
		systolic.targets.create target_type: :current_value, direction: :at_most, period: :all_time

		diastolic = Metric.create title: 'Diastolic Blood Pressure', default_value_type: 'current_value', aliases: ['dbp', 'diastolic'], unit: mmhg 
		diastolic.targets.create target_type: :current_value, direction: :at_most, period: :all_time


		
		bs = Metric.create title: 'Blood Sugar', default_value_type: 'current_value', aliases: ['glucose level', 'blood glucose'], unit: mgdl
		
		pbf = Metric.create title: 'Percent Body Fat', default_value_type: 'current_value', aliases: ['pbf', 'bodyfat', 'body fat', 'body fat percent'], unit: per
		pbf.targets.create target_type: :current_value, direction: :at_most, period: :all_time

		bmi = Metric.create title: 'Body Mass Index', default_value_type: 'current_value', aliases: ['bmi'], unit: bmi
		bmi.targets.create target_type: :current_value, direction: :at_most, period: :all_time

		temp = Metric.create title: 'Body Temperature', default_value_type: 'current_value', aliases: ['temp', 'temperature'], unit: celcius
		#bmi.targets.create target_type: :current_value, direction: :at_most, period: :all_time

		md = Metric.create title: 'Mood', default_value_type: 'avg_value', aliases: [ 'feeling', 'happiness' ], unit: per, default_period: 'day'
		md.targets.create target_type: :avg_value, direction: :at_least, period: :day, value: 75
		md = Metric.create title: 'Energy', default_value_type: 'avg_value', aliases: [ 'energy level' ], unit: per, default_period: 'day'
		md.targets.create target_type: :avg_value, direction: :at_least, period: :day, value: 75

		nutrition = Metric.create title: 'Calories', default_value_type: 'sum_value', 	aliases: ['cal', 'cals', 'calory', 'calorie'], unit: cal, default_period: 'day'
		nutrition.targets.create target_type: :sum_value, direction: :at_most, period: :day, value: 2000

		nutrition = Metric.create title: 'Calories Burned', default_value_type: 'sum_value', 	aliases: ['cals burned', 'burned'], unit: cal, default_period: 'day'
		nutrition.targets.create target_type: :sum_value, direction: :at_least, period: :day, value: 400


		nutrition = Metric.create title: 'Blocks', default_value_type: 'sum_value', 	aliases: ['block'], unit: block, default_period: 'day'
		nutrition.targets.create target_type: :sum_value, direction: :at_most, period: :day, value: 15

		nutrition = Metric.create title: 'Protein', default_value_type: 'sum_value',	aliases: ['prot', 'grams protein', 'grams of protein' ], unit: g, default_period: 'day'
		nutrition.targets.create target_type: :sum_value, direction: :at_least, period: :day, value: 80

		nutrition = Metric.create title: 'Fat', default_value_type: 'sum_value', 	aliases: ['fat', 'grams fat', 'grams of fat' ], unit: g, default_period: 'day'
		nutrition.targets.create target_type: :sum_value, direction: :at_most, period: :day, value: 20

		nutrition = Metric.create title: 'Carb', default_value_type: 'sum_value', 		aliases: ['carb', 'carbs', 'carbohydrates', 'grams carb', 'grams of carb', 'net carbs' ], unit: g, default_period: 'day'
		nutrition.targets.create target_type: :sum_value, direction: :at_most, period: :day, value: 40
		
		nutrition = Metric.create title: 'Sugar', default_value_type: 'sum_value', 	aliases: ['sugars', 'grams sugar', 'grams of sugar' ], unit: g, default_period: 'day'
		nutrition.targets.create target_type: :sum_value, direction: :at_most, period: :day, value: 20
		
		nutrition = Metric.create title: 'Water', default_value_type: 'sum_value', 	aliases: ['of water' ], unit: ml, default_period: 'day'
		nutrition.targets.create target_type: :sum_value, direction: :at_least, period: :day, period: :day, value: 1892.71

		nutrition = Metric.create title: 'Juice', default_value_type: 'sum_value', 	aliases: ['of juice', 'fruit juice', 'orange juice', 'apple juice' ], unit: ml, default_period: 'day'
		nutrition.targets.create target_type: :sum_value, direction: :at_least, period: :day, period: :week, value: 946.353

		nutrition = Metric.create title: 'Soda', default_value_type: 'sum_value', 	aliases: [ 'of soda', 'coke', 'pepsi' ], unit: ml, default_period: 'day'
		nutrition.targets.create target_type: :sum_value, direction: :at_most, period: :day, period: :week, value: 946.353

		nutrition = Metric.create title: 'Alcohol', default_value_type: 'sum_value', 	aliases: [ 'liquor', 'of alcohol' ], unit: ml, default_period: 'day'
		nutrition.targets.create target_type: :sum_value, direction: :at_most, period: :week, value: 120

		nutrition = Metric.create title: 'Beer', default_value_type: 'sum_value', 	aliases: [ 'beers', 'of beer' ], unit: ml, default_period: 'day'
		nutrition.targets.create target_type: :sum_value, direction: :at_most, period: :week, value: 120

		nutrition = Metric.create title: 'Wine', default_value_type: 'sum_value', 	aliases: [ 'wines', 'of wine' ], unit: ml, default_period: 'day'
		nutrition.targets.create target_type: :sum_value, direction: :at_most, period: :week, value: 120


		act = Metric.create title: 'Sleep', default_value_type: 'sum_value', 	aliases: ['slp', 'sleeping', 'slept', 'nap', 'napping', 'napped'], unit: sec, default_period: 'day'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :day, value: 28800

		act = Metric.create title: 'Meditation', default_value_type: 'sum_value', aliases: ['med', 'meditating', 'meditated'], unit: sec, default_period: 'day'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :day, value: 1200

		act = Metric.create title: 'Steps', default_value_type: 'sum_value', aliases: ['step', 'stp', 'stepped' ], unit: none, default_period: 'day'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :day, value: 10000

		act = Metric.create title: 'Drive', default_value_type: 'sum_value', 	aliases: ['drv', 'driving', 'drove'], unit: sec, default_period: 'day'
		act.targets.create target_type: :sum_value, direction: :at_most, period: :week, value: 7200
		act = Metric.create title: 'Cook', default_value_type: 'sum_value', 	aliases: ['cooking', 'cooked'], unit: sec, default_period: 'week'
		act.targets.create target_type: :sum_value, direction: :at_most, period: :week, value: 25200
		act = Metric.create title: 'Clean', default_value_type: 'sum_value', 	aliases: ['cln', 'cleaning', 'cleaned'], unit: sec, default_period: 'week'
		act.targets.create target_type: :sum_value, direction: :at_most, period: :week, value: 7200

		act = Metric.create title: 'Work', default_value_type: 'sum_value', 	aliases: ['wrk', 'working', 'worked'], unit: sec, default_period: 'week'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :week, value: 144000
		act = Metric.create title: 'Walk', default_value_type: 'sum_value', 	aliases: ['wlk', 'walking', 'walked'], unit: sec, default_period: 'day'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :week, value: 7200
		act = Metric.create title: 'Cycle', default_value_type: 'sum_value', aliases: ['cycling', 'cycled', 'bike', 'biked', 'biking', 'bicycling', 'bicycled', 'bicycle' ], unit: sec, default_period: 'day'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :week, value: 3600
		act = Metric.create title: 'Swim', default_value_type: 'sum_value', aliases: ['swimming', 'swam'], unit: sec, default_period: 'week'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :week, value: 3600
		act = Metric.create title: 'Run', default_value_type: 'sum_value', aliases: ['running', 'ran', 'jog', 'jogging', 'jogged'], unit: sec, default_period: 'day'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :week, value: 3600


		act = Metric.create title: 'Plank Time', default_value_type: 'sum_value', aliases: ['plank', 'planked', 'planking'], unit: sec, movement: Movement.find_by_alias( 'plank' ), default_period: 'day'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :day, value: 20

		act = Metric.create title: 'Push-ups', default_value_type: 'sum_value', aliases: ['pushup', 'push', 'pushshups'], unit: rep, movement: Movement.find_by_alias( 'pushup' ), default_period: 'day'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :day, value: 20
		
		act = Metric.create title: 'Pull-ups', default_value_type: 'sum_value', aliases: ['pullup', 'pull-up', 'pull', 'pullups'], unit: rep, movement: Movement.find_by_alias( 'pullup' ), default_period: 'day'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :day, value: 10

		act = Metric.create title: 'Burpees', default_value_type: 'sum_value', aliases: ['burpee'], unit: rep, movement: Movement.find_by_alias( 'burpee' ), default_period: 'day'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :day, value: 10

		act = Metric.create title: 'Squats', default_value_type: 'sum_value', aliases: ['squat'], unit: rep, movement: Movement.find_by_alias( 'squat' ), default_period: 'day'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :day, value: 25

		act = Metric.create title: 'Sit-ups', default_value_type: 'sum_value', aliases: ['situp', 'sit-up', 'situps'], unit: rep, movement: Movement.find_by_alias( 'situp' ), default_period: 'day'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :day, value: 10
		
		
		act = Metric.create title: 'Watch TV', default_value_type: 'sum_value', aliases: ['tv', 'screen time', 'watch video', 'wathed tv', 'watched', 'watching', 'watched video', 'watching video', 'watching tv'], unit: sec, default_period: 'week'
		act.targets.create target_type: :sum_value, direction: :at_most, period: :week, value: 3600

		act = Metric.create title: 'Video Game', default_value_type: 'sum_value', aliases: ['play video game', 'computer game', 'play xbox', 'xbox', 'play playstation', 'playstation', 'nintentndo', 'play nintendo', 'play on phone'], unit: sec, default_period: 'week'
		act.targets.create target_type: :sum_value, direction: :at_most, period: :week, value: 3600


		wkt = Metric.create title: 'Workout', default_value_type: 'sum_value', aliases: ['wkout', 'worked out', 'exercise', 'exercised', 'work out', 'working out', 'exercising'], unit: sec, default_period: 'week'
		act.targets.create target_type: :sum_value, direction: :at_least, period: :week, value: 10800

		wod = Metric.create title: 'WoD', default_value_type: 'count', aliases: ['workout of the day', 'crossfit', 'cross fit'], unit: sec, default_period: 'week'
		wod.targets.create target_type: :count, direction: :at_least, period: :week, value: 4
		# workouts must have time... record scores, reps, etc as sub observations.
		# bmi = Metric.create title: 'AMRAP', default_value_type: 'activity', aliases: ['amrap'], unit: 'rep'



		act = Metric.create title: 'Max Bench', default_value_type: 'max_value', aliases: ['bench', 'bench press'], unit: kg, movement: Movement.find_by_alias( 'bench' )
		act.targets.create target_type: :max_value, direction: :at_least, period: :all_time
		
		act = Metric.create title: 'Max Deadlift', default_value_type: 'max_value', aliases: ['deadlift', 'dl', 'dead lift'], unit: kg, movement: Movement.find_by_alias( 'dl' )
		act.targets.create target_type: :max_value, direction: :at_least, period: :all_time

		act = Metric.create title: 'Max Backsquat', default_value_type: 'max_value', aliases: ['squat', 'back squat', 'max squat'], unit: kg, movement: Movement.find_by_alias( 'squat' )
		act.targets.create target_type: :max_value, direction: :at_least, period: :all_time
		
		act = Metric.create title: 'Max Press', default_value_type: 'max_value', aliases: ['press'], unit: kg, movement: Movement.find_by_alias( 'press' )
		act.targets.create target_type: :max_value, direction: :at_least, period: :all_time
		
		act = Metric.create title: 'Max Clean', default_value_type: 'max_value', aliases: ['clean', 'power clean'], unit: kg, movement: Movement.find_by_alias( 'cln' )
		act.targets.create target_type: :max_value, direction: :at_least, period: :all_time
		
		act = Metric.create title: 'Max Clean & Jerk', default_value_type: 'max_value', aliases: ['clean n jerk', 'clean and jerk', 'clean jerk'], unit: kg, movement: Movement.find_by_alias( 'c&j' )
		act.targets.create target_type: :max_value, direction: :at_least, period: :all_time
		
		act = Metric.create title: 'Max Snatch', default_value_type: 'max_value', aliases: ['snatch'], unit: kg, movement: Movement.find_by_alias( 'snatch' )
		act.targets.create target_type: :max_value, direction: :at_least, period: :all_time
		
		act = Metric.create title: 'Max Plank Time', default_value_type: 'max_value', aliases: ['max plank'], unit: sec, movement: Movement.find_by_alias( 'plank' )
		act.targets.create target_type: :max_value, direction: :at_least, period: :all_time

		act = Metric.create title: '100m Time', default_value_type: 'min_value', aliases: ['one hundred', 'hundred time', 'hundred meter time', 'hundred meter dash', '100 meter dash', '100 meter time'], unit: sec, movement: Movement.find_by_alias( 'run' )
		act.targets.create target_type: :min_value, direction: :at_most, period: :all_time
		
		act = Metric.create title: '400m Time', default_value_type: 'min_value', aliases: ['four hundred', 'four hundred time', 'four hundred meter time', 'four hundred meter dash', '400 meter dash', '400 meter time'], unit: sec, movement: Movement.find_by_alias( 'run' )
		act.targets.create target_type: :min_value, direction: :at_most, period: :all_time
		
		act = Metric.create title: 'Mile Time', default_value_type: 'min_value', aliases: ['mile', 'one mile', 'one mile run', '1 mile run', '1 mile'], unit: sec, movement: Movement.find_by_alias( 'run' )
		act.targets.create target_type: :min_value, direction: :at_most, period: :all_time

		act = Metric.create title: 'Max Pushups', default_value_type: 'max_value', aliases: ['max pushup'], unit: rep, movement: Movement.find_by_alias( 'pushup' )
		act.targets.create target_type: :max_value, direction: :at_least, period: :all_time
		
		act = Metric.create title: 'Max Pullups', default_value_type: 'max_value', aliases: ['max pullup'], unit: rep, movement: Movement.find_by_alias( 'pullup' )
		act.targets.create target_type: :max_value, direction: :at_least, period: :all_time
		
		act = Metric.create title: 'Max Burpees', default_value_type: 'max_value', aliases: ['max burpee'], unit: rep, movement: Movement.find_by_alias( 'burpee' )
		act.targets.create target_type: :max_value, direction: :at_least, period: :all_time
		
		act = Metric.create title: 'Max Situps', default_value_type: 'max_value', aliases: ['max situp'], unit: rep, movement: Movement.find_by_alias( 'situp' )
		act.targets.create target_type: :max_value, direction: :at_least, period: :all_time

		act = Metric.create title: 'Round of Golf', default_value_type: 'min_value', aliases: ['golf', 'golfing', 'golfed', 'golf score'], unit: score
		act.targets.create target_type: :min_value, direction: :at_most, period: :all_time, value: 80


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

		Equipment.delete_all
		Movement.delete_all

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
		candle = Movement.create title: 'Candlestick', aliases: [ 'cs', 'cndlstk' ]
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
