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
		log_start_observation: {
			utterances: [
				# (that) (i) (am) start(ed|ing) (to) working
				'(?:that )?\s*(?:i )?\s*(?:am )?\s*(start|tim)(?:ed|ing)?\s*(?:to )?\s*(?:a |an )?\s*{action}',
			],
			slots: {
				action: 'Action',
			}
		},
		log_stop_observation: {
			utterances: [
				"(?:to )?\s*(?:that )?\s*(?:i )?\s*(stop|end|finish|complete)(?:ed|ing|ped)?\s*{action}\s*(?:timer)?",
			],
			slots: {
				action: 'Action',
			}
		},
		log_eaten_observation: {
			utterances: [
				# 'i ate {value} {unit} of {action}',
				# 'i ate {value}{unit} of {action}',
				'i ate {quantity} serving of {food}',
				# 'i ate {quantity} {measure} of {food}',
				# 'i ate {quantity} {food}',
				'i ate {portion} portion of {food}',
			],
			slots: {
				quantity: 'Number',
				food: 'Food',
				measure: 'Measure',
				portion: 'Number',
			}
		},
		report_eaten_observation: {
			utterances: [
				'how many calories (did|have) i (eaten|eat) {time_period}',
				'how much (did|have) i (eaten|eat) {time_period}',
				'how many calories (did|have) i (eaten|eat) in the {time_period}',
				'how much (did|have) i (eaten|eat) in the {time_period}',
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
		Unit: {
			regex: [
				'[a-zA-Z\.]*\s*[a-zA-Z\.]*\s*[a-zA-Z\.]*\s*[a-zA-Z\.]+'
			],
			values: [
				{ value: "height", synonyms: [] },
		        { value: "weight", synonyms: [] },
		        { value: "hips", synonyms: [] },
		        { value: "resting heart rate", synonyms: [] },
		        { value: "systolic blood pressure", synonyms: [] },
		        { value: "diastolic blood pressure", synonyms: [] },
		        { value: "blood pressure", synonyms: [] },
		        { value: "precent body fat", synonyms: [] },
		        { value: "heart rate", synonyms: [] },
		        { value: "pulse", synonyms: [] },
		        { value: "systolic", synonyms: [] },
		        { value: "diastolic", synonyms: [] },
		        { value: "body fat", synonyms: [] },
		        { value: "B.M.I.", synonyms: [] },
		        { value: "B M I", synonyms: [] },
		        { value: "Calories", synonyms: [] },
		        { value: "cal", synonyms: [] },
		        { value: "cals", synonyms: [] },
		        { value: "protein", synonyms: [] },
		        { value: "grams protein", synonyms: [] },
		        { value: "grams of protein", synonyms: [] },
		        { value: "carbs", synonyms: [] },
		        { value: "carbohydrates", synonyms: [] },
		        { value: "sleep", synonyms: [] },
		        { value: "Working", synonyms: [] },
		        { value: "Work", synonyms: [] },
		        { value: "miles", synonyms: [] },
		        { value: "kilometers", synonyms: [] },
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

		help_message = get_dialog('help', default: "To log fitness information just say \"I ate 100 calories\", or use a fitness timer by saying \"start run timer\".  Life Meter will remember, report and provide insights into what you have told it.")

		add_speech( help_message )

	end

	def launch
		# Process your Launch Request
		if user.present?
			launch_message = get_dialog('launch_user', default: "Welcome to Life Meter, an AMRAP Life skill.  To log fitness information just say \"I ate 100 calories\", or use a fitness timer by saying \"start run timer\".  Life Meter will remember, report and provide insights into what you have hold it.")

			add_speech(launch_message)
		else
			launch_message = get_dialog('launch_guest', default: "Welcome to Life Meter, an AMRAP Life skill.  To log fitness information just say \"I ate 100 calories\", or use a fitness timer by saying \"start run timer\".  Life Meter will remember, report and provide insights into what you have hold it.  To get started click this link, and complete the Life Meter skill registration on AMRAPLife.")

			add_speech(launch_message)
			add_login_prompt('Create your Life Meter Account on AMRAPLife', '', 'In order to record and report your metrics you must first create a Life Meter account on AMRAPLife.')
		end
		# add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )

	end

	def login
		launch_message = get_dialog('login', default: "Click this link to complete the Life Meter skill registration on AMRAP Life")


		add_speech( launch_message )
		add_login_prompt('Create your Life Meter Account on AMRAPLife', '', 'In order to record and report your metrics you must first create a Life Meter account on AMRAPLife.')

	end

	def log_eaten_observation
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

		observed_metric = get_user_metric( user, 'ate', 'calories' )

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

	def log_metric_observation
		unless user.present?
			login
			return
		end

		# @todo parse notes
		notes = nil
		sys_notes = nil

		if params[:action].present?

			observed_metric = get_user_metric( user, params[:action], params[:unit] )

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

		observed_metric = get_user_metric( user, params[:action], 'sec' )

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

		observed_metric = get_user_metric( user, params[:action], 'sec' )

		if observed_metric.errors.present?
			add_speech("I'm sorry, I don't know how to log information about #{params[:action]}. #{observed_metric.errors.full_messages.join('. ')}")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found' )
			return
		elsif observed_metric.nil?
			add_speech("I'm sorry, I don't know how to log information about #{params[:action]}.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found' )
			return
		end

		observations = user.observations.where( 'started_at is not null' ).order( started_at: :desc )
		observations = observations.where( observed: observed_metric ) if observed_metric.present?
		observation  = observations.first
		# observation = user.observations.where( observed_type: 'Metric', observed: observed_metric ).where( 'started_at is not null' ).order( started_at: :asc ).last

		if observation.present?
			observation.stop!
			add_speech("Stopping your #{params[:action]} timer at #{observation.value.to_i} #{observation.unit}" )
			sys_notes = "Spoke: 'Stopping your #{params[:action]} timer at #{observation.value.to_i} #{observation.unit}'"
		else
			add_speech("I can't find any running #{params[:action]} timers.")
			sys_notes = "I can't find any running #{params[:action]} timers."
		end

		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'updated', source: options[:source], result_status: 'success', system_notes: sys_notes )

	end

	def report_eaten_observation
		unless user.present?
			login
			return
		end

		observed_metric = get_user_metric( user, 'ate', 'calories' )
		time_period = params[:time_period].downcase.gsub(/\s+/,' ')

		puts "'#{time_period}'"

		if time_period == 'today'
			range = Time.now.beginning_of_day..Time.now.end_of_day
		elsif time_period == 'yesterday'
			range = 1.day.ago.beginning_of_day..1.day.ago.end_of_day
		elsif ( matches = time_period.match(/this (?'unit'week|month|year)/) ).present?
			unit = matches['unit']
			range = Time.now.try("beginning_of_#{unit}").beginning_of_day..Time.now.try("end_of_#{unit}").end_of_day
		elsif ( matches = time_period.match(/last (?'unit'week|month|year)/) ).present?
			unit = matches['unit']
			range = 1.try(unit).ago.try("beginning_of_#{unit}").beginning_of_day..1.try(unit).ago.try("end_of_#{unit}").end_of_day
		elsif ( matches = time_period.match(/last (?'amount'.+) (?'unit'days|weeks|months|years)/) ).present?
			amount = NumbersInWords.in_numbers( matches['amount'] )
			unit = matches['unit']
			range = amount.try(unit).ago.beginning_of_day..Time.now
		else
			add_speech("Sorry, I don't understand that.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found' )
			return
		end

		calories = Observation.where( user: user, observed: Metric.where( user_id: user, title: 'ate' ), created_at: range ).sum(:value)

		add_speech("#{calories.to_i} calories.")
		user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'success' )

	end

	def set_name
		user.update( first_name: params[:name] )
		add_speech("OK, from now on I'll call you #{params[:name]}.")
		user.user_inputs.create( content: raw_input, result_obj: user, action: 'updated', source: options[:source], result_status: 'success', system_notes: "Spoke: 'OK, from now on I'll call you #{params[:name]}.'" )
	end

	def stop

		add_speech("Stopping.")

	end

	private

	def get_user_metric( user, action, unit )

		if action.present?
			action = action.gsub( /(log|record|to|my|todays|is|was|=|i|for)/i, '' ).strip

			observed_metric = Metric.where( user_id: user ).find_by_alias( action.downcase )
			observed_metric ||= Metric.where( user_id: nil ).find_by_alias( action.downcase ).try(:dup)
			observed_metric ||= Metric.new( title: action, unit: unit ) if action.present?
			observed_metric.update( user: user ) if observed_metric.present?

		end

		observed_metric
	end

end
