class ObservationBotService < AbstractBotService

	 add_intents( {
		cancel: {
			utterances: [ 'cancel' ],
			slots: {}
		},
   		stop: {
   			utterances: [ 'stop', 'pause' ],
			slots: {}
   		},
   		resume: {
   			utterances: [ 'resume' ],
			slots: {}
   		},
		check_metric: {
			utterances: [
				'(to)?\s*check\s*(my)?\s*{action}',
				 ],
			slots: {
				action: 'Action',
			}
		},
		define: {
			utterances: [
				'(?:to)?\s*def(?:ine)?\s*{term}',
			],
			slots: {
				term: 'Notes',
			}
		},
		get_motivation: {
			utterances: [
				'(?:to )?\s*(inspire |motivate )\s*me',
				'(?:to )?\s*(?:for )?\s*(?:give me )?\s*(inspiration|motivation)'
			 ],
 			slots: {}
		},
		help: {
			utterances: [ 'help', 'for help' ]
		},
		hello: {
			utterances: [ 'hi', 'hey', 'yo', 'hello', 'hi there', 'good morning', 'good afternoon' ]
		},
		launch: {
			utterances: [ '' ]
		},
		login: {
			utterances: [ 'login', 'sign me in', 'sign in', 'log in', 'log me in' ]
		},
		log_drink_observation:{
			utterances: [
				'(?:that)?(?:i)?\s*(drank|drink)\s*{value}\s*{action}',
				#'(?:that)?(?:i)?\s*(drank|drink)\s*{value}\s*{unit}\s*{action}',
			],
			slots: {
				action: 'Action',
				value: 'Amount',
				unit: 'Unit',
			},
		},
		log_duration_observation: {
			utterances: [
				'(?:that)?(?:i)?\s*{action}\s*for\s*{duration}',
			],
			slots: {
				action: 'Action',
				duration: 'Notes',
			}
		},
		assign_metric: {
			utterances: [
				'(?:that)?\s*(?:i)?\s*(?:want)?\s*(?:to)?\s*track {action}',
				'(?:that)?\s*(?:i)?\s*(?:want)?\s*(?:to)?\s*track {action}\s*{unit}',
			],
			slots: {
				action: 'Action',
				unit: 'Unit',
			}
		},
		log_journal_observation: {
			utterances: [
				'(?:to)?\s*journal\s*(that)?{notes}',
				'dear diary\s*{notes}',
			],
			slots: {
				notes: 'Notes',
			}
		},


		workout_start: {
			utterances: [
				# (that) (i) (am) start(ed|ing) (to) working
				'(to )?(i am )?(start|starting) the workout of the day',
				'(to )?(i am )?(start|starting) workout of the day',
				'(to )?(i am )?(start|starting) working out',
				'(to )?(i am )?(start|starting) the workout',
				'(to )?(i am )?(start|starting) the wod',
				'(to )?(i am )?(start|starting) wod',
				'(to )?(i am )?(start|starting) the {workoutname} workout',
				'(to )?(i am )?(start|starting) {workoutname} workout',
			],
			slots:{
				workoutname: 'WorkoutName',
			},
		},

		workout_complete: {
			utterances: [
				'(to )?(i am )?(stop|done|finished|finish|complete) the workout of the day',
				'(to )?(i am )?(stop|done|finished|finish|complete) workout of the day',
				'(to )?(i am )?(stop|done|finished|finish|complete) the wod',
				'(to )?(i am )?(stop|done|finished|finish|complete) workout',
				'(to )?(i am )?(stop|done|finished|finish|complete) the workout',
				'(to )?(i am )?(stop|done|finished|finish|complete) working out',
				'(to )?(i am )?(stop|done|finished|finish|complete) wod',
				'(to )?(i am )?(stop|done|finished|finish|complete) the {workoutname} workout',
			],
			slots:{
				workoutname: 'WorkoutName',
			},
		},

		log_start_observation: {
			utterances: [
				# (that) (i) (am) start(ed|ing) (to) working
				'(?:to)?(?:that )?\s*(?:i )?\s*(?:am )?\s*(start|tim)(?:ed|ing)?\s*(?:to )?\s*(?:a |an )?\s*{action}',
			],
			slots: {
				action: 'Action',
			}
		},
		log_stop_observation: {
			utterances: [
				"(?:to )?\s*(?:that )?\s*(?:i )?\s*(stop|end|finish|complete)(?:ed|ing|ped)?\s*(?:my)?\s*{action}\s*(?:timer)?",
			],
			slots: {
				action: 'Action',
			}
		},

		report_last_value_observation:{
			utterances: [
				# what is my weight
				'what (is|was) (?:my )?\s*{action} {time_period}',
				'what (is|was) (?:my )?\s*{action}',
			],
			slots: {
				action: 'Action',
				time_period: 'TimePeriod',
			}
		},
		target_remaining:{
			utterances: [
				'how (much|many) {action} do I have left',
				],
			slots:{
				action: 'Action',
				unit: 'Unit'
				},
		},

		# report_sum_value_observation: {
		# 	utterances: [
		# 		# how many calories have I eaten
		# 		'how (many|much|many)\s*(calories|food )\s*.+(eat|ate|eaten)',
		# 		'how (many|much|many)\s*(calories|food )\s*.+(eat|ate|eaten)\s*{time_period}',

		# 		'how (much|many|long)\s*(?:do|did|have|i)?\s*(?:i )?\s*{action} {time_period}',
		# 		'how (much|many|long)\s*(?:do|did|have|i)?\s*(?:i )?\s*{action}',

		# 	],
		# 	slots: {
		# 		action: 'Action',
		# 		time_period: 'TimePeriod',
		# 	}
		# },

		set_name: {
			utterances: [
				'(?:to )?\s*call me {name}',
				'(?:that )?\s*my name is {name}'
				],
			slots:{
				name: 'Name',
			},
		},

		stop: {
			utterances: [ 'stop' ]
		},
		log_metric_observation: {
			utterances: [
				'i ate {value} {unit} of {action}',
				'i ate {value}{unit} of {action}',
				# for input like....
				# log weight = 176
				# log weight is 176
				# to log that wt is 194
				# weight 179lbs
				'(?:to )?\s*(?:log |record )?\s*(?:that )?\s*{action}\s*(?:=|is|was)?\s*{value}',
				'(?:to )?\s*(?:log |record )?\s*(?:that )?\s*{action}\s*(?:=|is|was)?\s*{value}\s*{unit}',

				# for input like....
				# log 172 for weight
				'(?:to )?\s*(?:log |record )?\s*{value} for {action}',
				'(?:to )?\s*(?:log |record )?\s*{value}\s*{unit} for {action}',

				# for input like....
				# I ran 3 miles
				'(?:that )?\s*i {action} {value}',
				'(?:that )?\s*i {action} {value}\s*{unit}',
				'(?:that )?\s*i {action} for {value}',
				'(?:that )?\s*i {action} for {value}\s*{unit}',
				'(?:that )?\s*i did {value}\s*{unit} of {action}'

			],
			slots: {
				value: 'Amount',
				action: 'Action',
				unit: 'Unit',
			}
		},
		# log_food_observation: {
		# 	utterances: [
		# 		'i ate {quantity} serving of {food}',
		# 		'i ate {quantity} {measure} of {food}',
		# 		'i ate {quantity} {food}',
		# 		'i ate {portion} portion of {food}',
		# 	],
		# 	slots: {
		# 		quantity: 'Number',
		# 		food: 'Food',
		# 		measure: 'Measure',
		# 		portion: 'Number',
		# 	}
		# },
		set_target:{
			utterances: [
				'set\s*(?:a)?\s*target of {value} for {action}',
				'set\s*(?:a)?\s*target of {value}\s*{unit} for {action}',
				'set\s*(?:a)?\s*target\s*(?:for)?{action} of {value}',
				'set\s*(?:a)?\s*target\s*(?:for)?{action} of {value}\s*{unit}',
			],
			slots:{
				action: 'Action',
				value: 'Amount',
				unit: 'Unit'
			},
		},

		tell_about: {
			utterances: [
				'(to)?\s*tell me about\s*(?:my)?\s*{action}',
			],
			slots:{
				action: 'Action',
			},
		},

		workout_describe: {
			utterances: [
				'what is {workoutname}(\?)?',
				'(to\s+)?describe {workoutname}(\?)?',
				'(to\s+)?describe today\'s workout(\?)?',
				'what is todays workout(\?)?',
				'what is the wod(\?)?',
				'what is the workout of the day(\?)?',
			],
			slots:{
				workoutname: 'WorkoutName',
			},
		},

		workout_list: {
			utterances: [
				'(to )?list workouts',
				'(to )?list all workouts',
			],
			slots:{},
		},

	} )

	add_slots( {
		Action: {
			regex: [
				'[a-zA-Z\s,\-]*[a-zA-Z]+'
			],
			values: [
		        { value: "ran", synonyms: [] },
		        { value: "swam", synonyms: [] },
		        { value: "biked", synonyms: [] },
		        { value: "walked", synonyms: [] },
		        { value: "jogged", synonyms: [] },
		        { value: "slept", synonyms: [] },
		        { value: "drove", synonyms: [] },
		        { value: "drive", synonyms: [] },
		        { value: "worked", synonyms: [] },
		        { value: "ate", synonyms: [] },
		        { value: "studying latin", synonyms: [] },
		        { value: "bike ride", synonyms: [] },
			]
		},
		Amount: {
			regex: [
				'[0-9.:&]+'
			],
			values: [
			]
		},
		Food: {
			regex: [
				'[a-zA-Z\.]*\s*[a-zA-Z\.]*\s*[a-zA-Z\.]*\s*[a-zA-Z\.]*\s*[a-zA-Z\.]+'
			],
			values: [
			]
		},
		Measure: {
			regex: [
				'[a-zA-Z]+'
			],
			values: [
		        { value: "cup", synonyms: [] },
		        { value: "gram", synonyms: [] },
		        { value: "teaspoon", synonyms: [] },
		        { value: "tablespoon", synonyms: [] },
		        { value: "liter", synonyms: [] },
		        { value: "ounce", synonyms: [] },
			]
		},
		Name: {
			regex: [
				'.+'
				],
				values: []
		},
		Notes: {
			regex: [
				'.+\z'
				],
				values: []
		},
		Unit: {
			regex: [
				'[a-zA-Z]+'
			],
			values: [
				{ value: "g", synonyms: [] },
		        { value: "kg", synonyms: [] },
		        { value: "in", synonyms: [] },
		        { value: "cm", synonyms: [] },
		        { value: "mile", synonyms: [] },
		        { value: "cal", synonyms: [] },
		        { value: "calorie", synonyms: [] },
		        { value: "km", synonyms: [] },
		        { value: "sec", synonyms: [] },
		        { value: "kilometer", synonyms: [] },
		        { value: "%", synonyms: [] },
		        { value: "lb", synonyms: [] },
		        { value: "pound", synonyms: [] },
		        { value: "rd", synonyms: [] },
		        { value: "rep", synonyms: [] },
	      ]
	  },
	  WorkoutName: {
		  regex: [
			  '.+'
		  ],
		  values: [
			  { value: "Glen", synonyms: [] },
			  { value: "Helen", synonyms: [] },
		]
	  }
  	} )

	def cancel
		add_speech("Cancelling")
		add_stop_audio()

		user.user_inputs.create( content: raw_input, action: 'cancel', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{raw_input || 'cancel'}'" ) if user.present?
	end

	def assign_metric
		unless user.present?
			login
			return
		end

		metric = get_user_metric( user, params[:action], params[:unit], true )

		response = "Great, I've added #{metric.title}. You can start logging it by saying '#{metric.title} is some value.'"
		add_speech( response )

		user.user_inputs.create( content: raw_input, result_obj: metric, action: 'created', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{response}'" )
	end

	def check_metric
		unless user.present?
			login
			return
		end

		metric = get_user_metric( user, params[:action], nil, false )

		if metric.nil?
			default_metric ||= Metric.where( user_id: nil ).find_by_alias( params[:action].downcase )
			action = default_metric.try( :title ) || params[:action]
			add_speech("Sorry, you haven't recorded anything for #{action} yet.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, you haven't recorded anything for #{action} yet.'" )
			return
		end

		if metric.target.present?
			if metric.target_type == 'value'
				current = metric.observations.order( created_at: :desc ).first
			else
				case metric.target_period
				when 'daily'
					range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
					target_period = 'per day'
					current_period = 'today'
				when 'weekly'
					range = Time.zone.now.beginning_of_week..Time.zone.now.end_of_day
					target_period = 'per week'
					current_period = 'this week'
				when 'monthly'
					range = Time.zone.now.beginning_of_month..Time.zone.now.end_of_day
					target_period = 'per month'
					current_period = 'this month'
				when 'yearly'
					range = Time.zone.now.beginning_of_year..Time.zone.now.end_of_day
					target_period = 'per year'
					current_period = 'this year'
				else
					range = "2001-01-01".to_date..Time.zone.now.end_of_day
					target_period = ''
					current_period = ''
				end

				case metric.target_type
				when 'sum_value'
					current = metric.observations.where( recorded_at: range ).sum( :value )
					target_type = "total"
				when 'count'
					current = metric.observations.where( recorded_at: range ).count
					target_type = "observations"
				when 'avg_value'
					current = metric.observations.where( recorded_at: range ).average( :value )
					target_type = "average"
				end

			end

			unit = metric.unit

			if metric.unit == 'sec'
				formatted_current = ChronicDuration.output( current, format: :chrono )
			else
				formatted_current = "#{current} #{metric.unit}s"
			end
			delta = current - metric.target

			if metric.unit == 'sec'
				formatted_delta = ChronicDuration.output( delta.abs, format: :chrono )
			else
				formatted_delta = "#{delta.abs} #{metric.unit}s"
			end
			direction = delta > 0 ? 'over' : 'under'

			if metric.target_type == 'value'
				response = "You have a target of #{metric.target_direction.gsub( /_/, ' ' )} #{metric.formatted_target}. Your most recent #{metric.title} is #{last_observation.formatted_value}. "
				response += "You are #{direction} your target by #{formatted_delta}."
			else
				response = "You have a target of #{metric.target_direction.gsub( /_/, ' ' )} #{metric.formatted_target} #{target_type} #{target_period}. Your #{target_type} so far #{current_period} is #{formatted_current}. "
				response += "You are #{direction} your target by #{formatted_delta}."
			end


		else
			response = "You haven't set a target for #{metric.title} yet. You last recorded #{last_observation.formatted_value} at #{last_observation.recorded_at.to_s( :long )}. You have logged #{formatted_total} so far today."
		end

		add_speech( response )

		user.user_inputs.create( content: raw_input, action: 'reported', source: options[:source], result_status: 'success', system_notes: "Spoke: #{response}" )

	end

	def define
		#term = Term.published.find_by_alias( params[:term] )
		match = params[:term].downcase.singularize.gsub( /\s+/, '' )
		term = Term.published.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match ).first
		term = Term.published.find_by_alias( match ) if term.nil?

		if term.nil?
			# try the movement DB
			term = Movement.published.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match ).first
			term = Movement.published.find_by_alias( match ) if term.nil?
		end

		if term.present?
			if term.aliases.include?( params[:term] )
				response = "#{params[:term]} is an alias for #{term.title} which means: #{term.sanitized_content}"
			else
				response = "#{term.title} means: #{term.sanitized_content}"
			end
			add_speech( response )
			user.user_inputs.create( content: raw_input, result_obj: term, action: 'read', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{response}.'" ) if user.present?
		else
			add_speech( "Hmmm, I don't know about #{params[:term]} yet." )
			user.user_inputs.create( content: raw_input, action: 'read', source: options[:source], result_status: 'failed', system_notes: "Spoke: 'Hmmm, I don't know about #{params[:term]} yet.'" ) if user.present?
		end
	end

	def get_motivation

		motivation = Inspiration.published.order('random()').first

		add_speech( ActionController::Base.helpers.strip_tags( motivation.description ) )

		user.user_inputs.create( content: raw_input, result_obj: motivation, action: 'read', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{motivation.description}'" ) if user.present?

	end

	def hello
		greetings = [
			'Howdy',
			'Whasssup',
			'Hey Hey',
			'Greetings',
			'Hi there'
		]

		if user.present?
			 message = "#{greetings.sample}, #{user}"
		else
			 message = "#{greetings.sample}"
		end

		add_speech( message )

		user.user_inputs.create( content: raw_input, action: 'read', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{message}'" ) if user.present?

	end

	def help

		help_message = get_dialog('help', default: "To log information just say \"I ate 100 calories\", or use a fitness timer by saying \"start a workout timer\". Life Meter will remember, report and provide insights into what you have told it.")

		add_speech( help_message )

		user.user_inputs.create( content: raw_input, action: 'read', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{help_message}'" ) if user.present?

	end

	def launch
		# Process your Launch Request
		if user.present?
			launch_message = get_dialog('launch_user', default: "Welcome to Life Meter by Life Meter. To log information just say \"I ate 100 calories\", or use a fitness timer by saying \"start run timer\".  Life Meter will remember, report and provide insights into what you have told it.")

			add_speech(launch_message)
		else
			launch_message = get_dialog('launch_guest', default: "Welcome to Life Meter by Life Meter. To log fitness information just say \"I ate 100 calories\", or use a fitness timer by saying \"start run timer\". Life Meter will remember, report and provide insights into what you have told it. To get started click this link, and complete the Life Meter skill registration on AMRAPLife.com.")

			add_speech(launch_message)
			add_login_prompt('Create your Life Meter Account on AMRAPLife.com', '', 'In order to record and report your metrics you must first create an account on AMRAPLife.com.')
		end
		# add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )

	end

	def login
		launch_message = get_dialog('login', default: "Click this link to complete the Life Meter skill registration on AMRAPLife.com")


		add_speech( launch_message )
		add_login_prompt('Create your Life Meter Account on AMRAPLife.com', '', 'In order to record and report your metrics you must first create an account on AMRAPLife.com.')

	end

	def log_duration_observation
		unless user.present?
			login
			return
		end
		# special construction to let Chronic Duration do it's thing on time-unit observations
		# cause {value} slots don't take min sec, etc.
		# of the form "(I) slept for 8hrs 24mins"

		metric = get_user_metric( user, params[:action], 'sec', true )
		value = ChronicDuration.parse( params[:duration] )

		if value.present?
			observation = metric.observations.create value: value

			response = "Logged #{observation.human_value} for #{metric.title}."
			add_speech( response )

			user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{response}'" )
		else
			response = "I'm sorry, I didn't understand that."
			add_speech( response )

			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'failed', system_notes: "Spoke: '#{response}'" )
		end


	end

	def log_food_observation
		unless user.present?
			login
			return
		end


		# @todo parse notes
		notes = nil


		food_results = []
		if params[:food].present?
			begin
				results = NutritionService.new.nutrition_information( query: params[:food], max: 4 )

				calories = results[:average_calories]
				calories = calories * params[:portion].to_i if params[:portion].present?

			rescue Exception => e
				NewRelic::Agent.notice_error(e)
				logger.error "log_eaten_observation error"
				logger.error e
				puts e.backtrace
			end

		end

		observed_metric = get_user_metric( user, 'ate', 'calories', true )

		if params[:quantity].present? && params[:measure].blank?

			add_speech("Logging that you ate #{params[:quantity]} #{params[:food]}.#{calories.present? ? " Approximately #{calories} calories." : ""}")

			observation = Observation.create( user: user, observed: observed_metric, value: calories, unit: 'calories', notes: notes )

		elsif params[:quantity].present? && params[:measure].present?

			add_speech("Logging that you ate #{params[:quantity]} #{params[:measure]} of #{params[:food]}.#{calories.present? ? " Approximately #{calories} calories." : ""}.")

			observation = Observation.create( user: user, observed: observed_metric, value: calories, unit: 'calories', notes: notes )

		elsif params[:portion].present?

			add_speech("Logging that you ate #{params[:portion]} portion of #{params[:food]}.#{calories.present? ? " Approximately #{calories} calories." : ""}")

			observation = Observation.create( user: user, observed: observed_metric, value: calories, unit: 'calories', notes: notes )

		else

			add_speech("Sorry, I don't understand.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found' )
			return

		end

		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success' )

	end

	def log_drink_observation
		unless user.present?
			login
			return
		end


		if params[:action].match( /of/ )
			metric_alias = params[:action].gsub( /.+of/, '' ).strip
			unit = params[:action].split( /of/ )[0]
		else
			unit = params[:action].match( /\S+\s/ ).to_s.strip
			metric_alias = params[:action].gsub( /\S+\s/, '' ).strip
		end

		metric = get_user_metric( user, metric_alias, unit, true )

		observation = Observation.create( user: user, observed: metric, value: params[:value], unit: unit )

		add_speech( observation.to_s( user ) )
		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: "Spoke: #{observation.to_s( user )}" )
	end


	def log_journal_observation
		unless user.present?
			login
			return
		end

		if params[:notes].present?
			observation = user.observations.create( notes: params[:notes] )
			add_speech( "I recorded your journal entry." )
			user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: "Spoke: 'I recorded your journal entry.'" )
		end
	end

	def log_metric_observation
		unless user.present?
			login
			return
		end

		# @todo parse notes
		notes = nil
		sys_notes = nil

		if params[:action].present?

			observed_metric = get_user_metric( user, params[:action], params[:unit], true )

			if observed_metric.nil?
				add_speech("I'm sorry, I don't know how to log information about #{params[:action]}.")
			else
				val = params[:value]
				# always store time as secs
				if val.match( /:/ )
					val = ChronicDuration.parse( val )
					params[:unit] ||= 'sec'
				elsif ['minute', 'minutes', 'min', 'mins'].include?( params[:unit] )
					params[:unit] = 'sec'
					val = val.to_i * 60
				elsif ['hour', 'hours', 'hr', 'hrs'].include?( params[:unit] )
					params[:unit] = 'sec'
					val = val.to_i * 3600
				end
				observation = Observation.create( user: user, observed: observed_metric, value: val, unit: params[:unit], notes: notes )

				add_speech( observation.to_s( user ) )

			end

		else

			observation = Observation.create( user: user, value: params[:value], unit: params[:unit], notes: notes )

			add_speech( observation.to_s( user ) )

		end

		if observation.present?
			sys_notes = "Logged #{observation.human_value} for #{observation.observed.title}."
		end
		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: sys_notes )

	end

	def log_start_observation
		unless user.present?
			login
			return
		end

		# @todo parse notes
		notes = nil

		params[:action] = params[:action].gsub( /timer/, '' )

		metric = get_user_metric( user, params[:action], 'sec', true )

		observation = Observation.create( user: user, observed: metric, started_at: Time.zone.now, notes: notes )
		add_speech("Starting your #{metric.title} timer")

		sys_notes = "Spoke: 'Starting your #{metric.title} timer'."

		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: sys_notes )

	end

	def log_stop_observation
		unless user.present?
			login
			return
		end
		sys_notes = ''

		metric = get_user_metric( user, params[:action], 'sec' )

		if metric.nil?
			default_metric ||= Metric.where( user_id: nil ).find_by_alias( params[:action].downcase )
			action = default_metric.try( :title ) || params[:action]
			add_speech("Sorry, you haven't recorded anything for #{action} yet.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, you haven't recorded anything for #{action} yet.'" )
			return
		end

		observations = user.observations.of( metric ).where( value: nil ).where( 'started_at is not null' ).order( started_at: :desc )
		observation  = observations.first

		if observation.present?
			observation.stop!
			add_speech("Stopping your #{metric.title} timer at #{observation.value.to_i} #{observation.unit}" )
			sys_notes = "Spoke: 'Stopping your #{metric.title} timer at #{observation.value.to_i} #{observation.unit}'"
		else
			add_speech("I can't find any running #{params[:action]} timers.")
			sys_notes = "I can't find any running #{params[:action]} timers."
		end

		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'updated', source: options[:source], result_status: 'success', system_notes: sys_notes )

	end

	def pause
		add_speech("Pausing workout.")
		add_stop_audio()
		user.user_inputs.create( content: raw_input, action: 'pause', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{raw_input || 'pause'}'" ) if user.present?
	end

	def resume
		add_speech("Resuming workout.")
		add_audio_url('https://cdn1.amraplife.com/assets/c45ca8e9-2a8f-4522-bdcb-b7df58f960f8.mp3', token: 'workout-player', offset: audio_player[:offset] )
		user.user_inputs.create( content: raw_input, action: 'resume', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{raw_input || 'resume'}'" ) if user.present?
	end

	# def report_sum_value_observation
	# 	unless user.present?
	# 		login
	# 		return
	# 	end

	# 	params[:action] ||= 'Calories'

	# 	observed_metric = get_user_metric( user, params[:action], nil, false )

	# 	time_period = params[:time_period] || 'today'
	# 	time_period = time_period.downcase.gsub(/\s+/,' ')

	# 	if observed_metric.nil?
	# 		default_metric ||= Metric.where( user_id: nil ).find_by_alias( params[:action].downcase )
	# 		action = default_metric.try( :title ) || params[:action]
	# 		add_speech("Sorry, you haven't recorded anything for #{action} yet.")
	# 		user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, you haven't recorded anything for #{action} yet.'" )
	# 		return
	# 	end

	# 	puts "'#{time_period}'"

	# 	if time_period == 'today'
	# 		range = Time.now.beginning_of_day..Time.zone.now.end_of_day
	# 	elsif time_period == 'yesterday'
	# 		range = 1.day.ago.beginning_of_day..1.day.ago.end_of_day
	# 	elsif ( matches = time_period.match(/this (?'unit'week|month|year)/) ).present?
	# 		unit = matches['unit']
	# 		range = Time.zone.now.try("beginning_of_#{unit}").beginning_of_day..Time.zone.now.try("end_of_#{unit}").end_of_day
	# 	elsif ( matches = time_period.match(/last (?'unit'week|month|year)/) ).present?
	# 		unit = matches['unit']
	# 		range = 1.try(unit).ago.try("beginning_of_#{unit}").beginning_of_day..1.try(unit).ago.try("end_of_#{unit}").end_of_day
	# 	elsif ( matches = time_period.match(/last (?'amount'.+) (?'unit'days|weeks|months|years)/) ).present?
	# 		amount = NumbersInWords.in_numbers( matches['amount'] )
	# 		unit = matches['unit']
	# 		range = amount.try(unit).ago.beginning_of_day..Time.zone.now
	# 	else
	# 		add_speech("Sorry, I don't understand that.")
	# 		user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found' )
	# 		return
	# 	end

	# 	sum = user.observations.of( observed_metric ).where( recorded_at: range ).sum( :value )
	# 	unit = observed_metric.unit
	# 	if observed_metric.unit == 'sec'
	# 		sum = ChronicDuration.output( sum, format: :chrono )
	# 		unit = ''
	# 	end

	# 	add_speech( "You logged #{sum} #{unit} of #{observed_metric.title} #{time_period}." )
	# 	sys_notes = "Spoke: 'You logged #{sum} #{unit} of #{observed_metric.title} #{time_period}.'"

	# 	user.user_inputs.create( content: raw_input, action: 'reported', source: options[:source], result_status: 'success', system_notes: sys_notes )

	# end

	def report_last_value_observation
		unless user.present?
			login
			return
		end

		observed_metric = get_user_metric( user, params[:action], nil, false )

		if observed_metric.nil?
			default_metric ||= Metric.where( user_id: nil ).find_by_alias( params[:action].downcase )
			action = default_metric.try( :title ) || params[:action]
			add_speech("Sorry, you haven't recorded anything for #{action} yet.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, you haven't recorded anything for #{action} yet.'" )
			return
		end

		time_period = params[:time_period] || ''
		time_period = time_period.downcase.gsub(/\s+/,' ')

		verb = "is"

		observations = user.observations.of( observed_metric ).order( recorded_at: :desc )

		if time_period == 'yesterday'
			observations = observations.where( "recorded_at <= :time", time: 1.day.ago.beginning_of_day )
		elsif ( matches = time_period.match(/last (?'unit'week|month|year)/) ).present?
			verb = 'was'
			unit = matches['unit']
			observations = observations.where( "recorded_at <= :time", time: 1.try(unit).ago.try("end_of_#{unit}").end_of_day )
		end

		obs = observations.first

		if obs.present?

			add_speech( "Your #{obs.observed.title} #{verb} #{obs.human_value} #{time_period}." )
			sys_notes = "Spoke: 'Your #{obs.observed.title} #{verb} #{obs.human_value} #{time_period}.'"

			user.user_inputs.create( content: raw_input, action: 'reported', source: options[:source], result_status: 'success', system_notes: sys_notes )
		else
			observed = observed_metric.try( :title ) || params[:action]
			add_speech("Sorry, you didn't record #{observed} for #{time_period}.")
			user.user_inputs.create( content: raw_input, action: 'reported', source: options[:source], result_status: 'not found', system_notes: "Spoke: 'Sorry, you didn't record #{observed} for #{time_period}.'" )
			return
		end

	end

	def set_name
		unless user.present?
			login
			return
		end
		user.update( first_name: params[:name] )
		add_speech("OK, from now on I'll call you #{params[:name]}.")
		user.user_inputs.create( content: raw_input, result_obj: user, action: 'updated', source: options[:source], result_status: 'success', system_notes: "Spoke: 'OK, from now on I'll call you #{params[:name]}.'" )
	end

	def set_target
		unless user.present?
			login
			return
		end
		metric = get_user_metric( user, params[:action], params[:unit], true )

		if metric.nil?
			default_metric ||= Metric.where( user_id: nil ).find_by_alias( params[:action].downcase )
			action = default_metric.try( :title ) || params[:action]
			add_speech("Sorry, I can't assign a target because you haven't recorded anything for #{action} yet.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, I can't assign a target because you haven't recorded anything for #{action} yet.'" )
			return
		end

		metric.update( target: params[:value] )
		add_speech( "I set a target of #{params[:value]} for #{metric.title}." )
		sys_notes = "Spoke: 'I set a target of #{params[:value]} for #{metric.title}.'"

		user.user_inputs.create( content: raw_input, result_obj: metric, action: 'updated', source: options[:source], result_status: 'success', system_notes: sys_notes )

	end

	def stop
		add_speech("Stopping.")
		add_stop_audio()
	end

	def target_remaining
		unless user.present?
			login
			return
		end
		metric = get_user_metric( user, params[:action], params[:unit], false )
		if metric.nil?
			default_metric ||= Metric.where( user_id: nil ).find_by_alias( params[:action].downcase )
			action = default_metric.try( :title ) || params[:action]
			add_speech("Sorry, you haven't recorded anything for #{action} yet.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, I you haven't recorded anything for #{action} yet.'" )
			return
		elsif metric.target.nil?
			add_speech("Sorry, you haven't a target for #{metric.title} yet. Say something like 'Set a target of 100 for #{metric.title}' to set a target.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, you haven't a target for #{metric.title} yet.'" )
			return
		end

		sum = user.observations.of( metric ).where( recorded_at: Time.now.beginning_of_day..Time.now.end_of_day ).sum( :value )
		target = metric.target
		delta = ( target-sum ).abs

		unit = metric.unit
		formatted_sum = sum
		formatted_target = target
		formatted_delta = delta

		if metric.unit == 'sec'
			formatted_sum = ChronicDuration.output( sum, format: :chrono )
			formatted_target = ChronicDuration.output( target, format: :chrono )
			formatted_delta = ChronicDuration.output( delta, format: :chrono )
			unit = ''
		end

		response = "Your #{metric.title} target is #{formatted_target} #{unit}. "
		if sum <= metric.target
			response += "You have logged #{formatted_sum} so far today, and you have #{formatted_delta} remaining."
		else
			response += "You have logged #{formatted_sum} so far today, and you are over by #{formatted_delta}."
		end

		add_speech( response )

		user.user_inputs.create( content: raw_input, action: 'reported', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{response}'" )
	end

	def tell_about
		unless user.present?
			login
			return
		end
		metric = get_user_metric( user, params[:action] )

		if metric.nil?
			default_metric ||= Metric.where( user_id: nil ).find_by_alias( params[:action].downcase )
			action = default_metric.try( :title ) || params[:action]
			add_speech("Sorry, you haven't recorded anything for #{action} yet.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, you haven't recorded anything for #{action} yet.'" )
			return
		end

		obs_count_total = user.observations.for( metric ).count
		obs_count_last_week = user.observations.for( metric ).where( recorded_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week ).count
		obs_count_this_week = user.observations.for( metric ).where( recorded_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week ).count

		average_value = user.observations.for( metric ).average( :value ).try( :round, 2 ) || 0
		min_value = user.observations.for( metric ).minimum( :value ) || 0
		max_value = user.observations.for( metric ).maximum( :value ) || 0
		value_sum = user.observations.for( metric ).sum( :value ) || 0

		if metric.unit == 'sec'
			average_value = ChronicDuration.output( average_value, format: :chrono )
			min_value = ChronicDuration.output( min_value, format: :chrono )
			max_value = ChronicDuration.output( max_value, format: :chrono )
			value_sum = ChronicDuration.output( value_sum, format: :chrono )
		end

		add_speech( "You have logged #{metric.title} #{obs_count_total} times in all. #{obs_count_last_week} times last week, and #{obs_count_this_week} times so far this week. The average value for #{metric.title} is #{average_value}. The max value is #{max_value} and the minimum is #{min_value}." )
		sys_notes = "Spoke: 'You have logged #{metric.title} #{obs_count_total} times in all. #{obs_count_last_week} times last week, and #{obs_count_this_week} times so far this week. The average value for #{metric.title} is #{average_value}. The max value is #{max_value} and the minimum is #{min_value}.'"

		user.user_inputs.create( content: raw_input, action: 'reported', source: options[:source], result_status: 'success', system_notes: sys_notes )

	end

	def workout_complete

		unless user.present?
			login
			return
		end

		observation = nil

		add_speech("Great!  I am logging your time.")
		sys_notes = "Spoke: 'Great!  I am logging your time.'."
		add_stop_audio()

		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'updated', source: options[:source], result_status: 'success', system_notes: sys_notes )

	end

	def workout_describe
		unless user.present?
			login
			return
		end

		workout_name = params[:workoutname]


		add_speech("Today's workout is the 3 minute airsquat challenge.  Do as many air squats as you can in 3 minutes.")
		sys_notes = "Spoke: 'Today's workout is the 3 minute airsquat challenge.  Do as many air squats as you can in 3 minutes.'."

		user.user_inputs.create( content: raw_input, action: 'created', source: options[:source], result_status: 'success', system_notes: sys_notes )

	end

	def workout_list
		unless user.present?
			login
			return
		end

		add_speech("These are our most popular workouts. 3 minute airsquat challenge. 3 minute push up challenge.  3 minute sit up challenge.")
		sys_notes = "Spoke: 'These are our most popular workouts. 3 minute airsquat challenge. 3 minute push up challenge.  3 minute sit up challenge.'."

		user.user_inputs.create( content: raw_input, action: 'created', source: options[:source], result_status: 'success', system_notes: sys_notes )

	end

	def workout_start
		unless user.present?
			login
			return
		end

		workout_name = params[:workoutname]

		observation = nil
		# metric = get_user_metric( user, workout_name, 'sec', true )
		#
		# observation = Observation.create( user: user, observed: metric, started_at: Time.zone.now, notes: notes )

		if workout_name.present?
			add_speech("Starting the #{workout_name} workout")
			sys_notes = "Spoke: 'Starting the #{workout_name} workout'."
		else
			add_speech("Starting the workout of the day")
			sys_notes = "Spoke: 'Starting the workout of the day'."
		end

		add_audio_url('https://cdn1.amraplife.com/assets/c45ca8e9-2a8f-4522-bdcb-b7df58f960f8.mp3', token: 'workout-player')

		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: sys_notes )


	end

	private

		def get_user_metric( user, action, unit=nil, create=false )

			if action.present?
				action = action.gsub( /(log |record |to |my | todays | is| are| was| = |i | for|timer)/i, '' ).strip

				observed_metric = Metric.where( user_id: user ).find_by_alias( action.downcase )
				if create
					observed_metric ||= Metric.where( user_id: nil ).find_by_alias( action.downcase ).try(:dup)
					observed_metric ||= Metric.new( title: action, unit: unit ) if action.present?
					observed_metric.update( user: user ) if observed_metric.present?
				end

			end

			observed_metric
		end

end
