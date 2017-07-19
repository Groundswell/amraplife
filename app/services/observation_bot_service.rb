class ObservationBotService < AbstractBotService

	 add_intents( {
		cancel: {
			utterances: [ 'cancel' ]
		},
		get_motivation: {
			utterances: [ 
				'(?:to )?\s*(inspire |motivate )\s*me',
				'(?:to )?\s*(?:for )?\s*(?:give me )?\s*(inspiration|motivation)'
				 ]
		},
		help: {
			utterances: [ 'help', 'for help' ]
		},
		launch: {
			utterances: [ '' ]
		},
		login: {
			utterances: [ 'login', 'sign me in', 'sign in', 'log in', 'log me in' ]
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
		report_sum_value_observation: {
			utterances: [
				# how many calories have I eaten
				'how (many|much)\s*(calories|food )\s*.+(eat|ate|eaten)',
				'how (many|much)\s*(calories|food )\s*.+(eat|ate|eaten)\s*{time_period}',

				'how (much|many|long) (do|did|have|i) (?:i )?\s*{action} {time_period}',
				'how (much|many|long) (do|did|have|i) (?:i )?\s*{action}',

			],
			slots: {
				time_period: 'TimePeriod',
			}
		},
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
		log_food_observation: {
			utterances: [
				'i ate {value} {unit} of {action}',
				'i ate {value}{unit} of {action}',
				'i ate {quantity} serving of {food}',
				'i ate {quantity} {measure} of {food}',
				'i ate {quantity} {food}',
				'i ate {portion} portion of {food}',
			],
			slots: {
				quantity: 'Number',
				food: 'Food',
				measure: 'Measure',
				portion: 'Number',
			}
		},
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

		stop: {
			utterances: [ 'stop' ]
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
  	} )

	def cancel

		add_speech("Cancelling")

	end

	def get_motivation

		motivation = Inspiration.published.order('random()').first

		add_speech( motivation.title )

		user.user_inputs.create( content: raw_input, result_obj: motivation, action: 'read', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{motivation.title}'" )
	end

	def help

		help_message = get_dialog('help', default: "To log information just say \"I ate 100 calories\", or use a fitness timer by saying \"start run timer\". AMRAP Life will remember, report and provide insights into what you have told it.")

		add_speech( help_message )

	end

	def launch
		# Process your Launch Request
		if user.present?
			launch_message = get_dialog('launch_user', default: "Welcome to AMRAP Life. To log information just say \"I ate 100 calories\", or use a fitness timer by saying \"start run timer\".  AMRAP Life will remember, report and provide insights into what you have told it.")

			add_speech(launch_message)
		else
			launch_message = get_dialog('launch_guest', default: "Welcome to AMRAP Life. To log fitness information just say \"I ate 100 calories\", or use a fitness timer by saying \"start run timer\". AMRAP Life will remember, report and provide insights into what you have told it. To get started click this link, and complete the AMRAP Life skill registration on AMRAPLife.com.")

			add_speech(launch_message)
			add_login_prompt('Create your AMRAP Life Account on AMRAPLife.com', '', 'In order to record and report your metrics you must first create a AMRAP Life account on AMRAPLife.com.')
		end
		# add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )

	end

	def login
		launch_message = get_dialog('login', default: "Click this link to complete the AMRAP Life skill registration on AMRAPLife.com")


		add_speech( launch_message )
		add_login_prompt('Create your AMRAP Life Account on AMRAPLife.com', '', 'In order to record and report your metrics you must first create a AMRAP Life account on AMRAPLife.com.')

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

		observed_metric = get_user_metric( user, params[:action], 'sec', true )

		if observed_metric.errors.present?
			add_speech("I'm sorry, I don't know how to log information about #{params[:action]}. #{observed_metric.errors.full_messages.join('. ')}")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found' ) if user.present?
			return
		elsif observed_metric.nil?
			add_speech("I'm sorry, I don't know how to log information about #{params[:action]}.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found' ) if user.present?
			return
		end

		observation = Observation.create( user: user, observed: observed_metric, started_at: Time.zone.now, notes: notes )
		add_speech("Starting your #{params[:action]} timer")

		sys_notes = "Spoke: 'Starting your #{params[:action]} timer'."

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

	def report_sum_value_observation
		unless user.present?
			login
			return
		end

		params[:action] ||= 'Calories'
		
		observed_metric = get_user_metric( user, params[:action], nil, false )
		
		time_period = params[:time_period] || 'today'
		time_period = time_period.downcase.gsub(/\s+/,' ')

		if observed_metric.nil?
			default_metric ||= Metric.where( user_id: nil ).find_by_alias( params[:action].downcase )
			action = default_metric.try( :title ) || params[:action]
			add_speech("Sorry, you haven't recorded anything for #{action} yet.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, you haven't recorded anything for #{action} yet.'" )
			return
		end

		puts "'#{time_period}'"

		if time_period == 'today'
			range = Time.now.beginning_of_day..Time.zone.now.end_of_day
		elsif time_period == 'yesterday'
			range = 1.day.ago.beginning_of_day..1.day.ago.end_of_day
		elsif ( matches = time_period.match(/this (?'unit'week|month|year)/) ).present?
			unit = matches['unit']
			range = Time.zone.now.try("beginning_of_#{unit}").beginning_of_day..Time.zone.now.try("end_of_#{unit}").end_of_day
		elsif ( matches = time_period.match(/last (?'unit'week|month|year)/) ).present?
			unit = matches['unit']
			range = 1.try(unit).ago.try("beginning_of_#{unit}").beginning_of_day..1.try(unit).ago.try("end_of_#{unit}").end_of_day
		elsif ( matches = time_period.match(/last (?'amount'.+) (?'unit'days|weeks|months|years)/) ).present?
			amount = NumbersInWords.in_numbers( matches['amount'] )
			unit = matches['unit']
			range = amount.try(unit).ago.beginning_of_day..Time.zone.now
		else
			add_speech("Sorry, I don't understand that.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found' )
			return
		end

		sum = user.observations.of( observed_metric ).where( recorded_at: range ).sum( :value )

		add_speech( "You logged #{sum} #{observed_metric.unit}s of #{observed_metric.title} #{time_period}." )
		sys_notes = "Spoke: 'You logged #{sum} #{observed_metric.unit}s of #{observed_metric.title} #{time_period}.'"

		user.user_inputs.create( content: raw_input, action: 'reported', source: options[:source], result_status: 'success', system_notes: sys_notes )

	end

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
		
		average_value = user.observations.for( metric ).average( :value ).round( 2 )
		min_value = user.observations.for( metric ).minimum( :value )
		max_value = user.observations.for( metric ).maximum( :value )
		value_sum = user.observations.for( metric ).sum( :value )

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
