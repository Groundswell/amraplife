class ObservationBotService < AbstractBotService

	 add_intents( {
		cancel: {
			utterances: [ 'cancel' ]
		},
		get_motivation: {
			utterances: [ 'motivate me', 'inspire me', 'to motivate me', 'to inspire me' ]
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
				'i ate {value} {unit} of {action}',
				'i ate {value}{unit} of {action}',
				'to (log|record) {value} for {action}',
				'to (log|record) {value} {unit} for {action}',
				'to (log|record) {value}{unit} for {action}',
				'to (log|record) {value} {unit}',
				'i did {value} {unit} of {action}',
				'i {action} for {value} {unit}',
				'i {action} {value} {unit}',
				'(log|record) {value} {unit}',
				'(log|record) {action} {value} {unit}',
				'(log|record) {action} {value}',
				'{action}={value} {unit}',
				'{action}={value}{unit}',
				'{action}={value}',
				'{action} (is|was) {value} {unit}',
				'{action} (is|was) {value}{unit}',
				'{value} {unit} for {action}',
				'{value}{unit} for {action}',
			],
			slots: {
				value: 'Amount',
				action: 'Action',
				unit: 'Unit',
			}
		},
		log_start_observation: {
			utterances: [
				"I am (starting|begining) a {action}",
				"to (start|begin) timing {action}",
				"to (start|begin) {action} timer",
				"to (start|begin) {action}",
		        "to time {action}",
		        "(start|begin) timing {action}",
		        "(start|begin) {action} timer",
		        "(start|begin) {action}",
		        "time {action}",
			],
			slots: {
				action: 'Action',
			}
		},
		log_stop_observation: {
			utterances: [
				"(stop|end) {action} timer",
				"(stop|end) timing {action}",
				"(stop|end) {action}",
				"to (stop|end) {action} timer",
				"to (stop|end) {action}",
				"I have (finished|completed) my {action}",
				"I have (finished|completed) {action}",
			],
			slots: {
				action: 'Action',
			}
		},
		log_eaten_observation: {
			utterances: [
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

		motivation = Inspiration.published.order('random()').first.title

		add_speech( motivation )
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

			Observation.create( user: user, observed: observed_metric, value: calories, unit: 'calories', notes: "I ate #{params[:quantity]} #{params[:food]}" )

		elsif params[:quantity].present? && params[:measure].present?

			add_speech("Logging that you ate #{params[:quantity]} #{params[:measure]} of #{params[:food]}.#{calories.present? ? " Approximately #{calories} calories." : ""}.")

			Observation.create( user: user, observed: observed_metric, value: calories, unit: 'calories', notes: "I ate #{params[:quantity]} #{params[:measure]} of #{params[:food]}" )

		elsif params[:portion].present?

			add_speech("Logging that you ate #{params[:portion]} portion of #{params[:food]}.#{calories.present? ? " Approximately #{calories} calories." : ""}")

			Observation.create( user: user, observed: observed_metric, value: calories, unit: 'calories', notes: "I ate #{params[:portion]} portion of #{params[:food]}" )

		else

			add_speech("Sorry, I don't understand.")

		end
	end

	def log_metric_observation
		unless user.present?
			login
			return
		end

		# @todo parse notes
		notes = nil

		if params[:action].present?

			observed_metric = get_user_metric( user, params[:action], params[:unit] )

			if observed_metric.nil?

				add_speech("I'm sorry, I don't know how to log information about #{params[:action]}.")

			else

				observation = Observation.create( user: user, observed: observed_metric, value: params[:value], unit: params[:unit], notes: notes )

				add_speech( observation.to_s( user ) )

			end

		else

			observation = Observation.create( user: user, value: params[:value], unit: params[:unit], notes: notes )

			add_speech( observation.to_s( user ) )

		end

	end

	def log_start_observation
		unless user.present?
			login
			return
		end

		observed_metric = get_user_metric( user, params[:action], 'seconds' )

		if observed_metric.errors.present?
			add_speech("I'm sorry, I don't know how to log information about #{params[:action]}. #{observed_metric.errors.full_messages.join('. ')}")
			return
		elsif observed_metric.nil?
			add_speech("I'm sorry, I don't know how to log information about #{params[:action]}.")
			return
		end

		Observation.create( user: user, observed: observed_metric, started_at: Time.zone.now, notes: "start #{params[:action]}" )
		add_speech("Starting your #{params[:action]} timer")

	end

	def log_stop_observation
		unless user.present?
			login
			return
		end

		observed_metric = get_user_metric( user, params[:action], 'seconds' )

		if observed_metric.errors.present?
			add_speech("I'm sorry, I don't know how to log information about #{params[:action]}. #{observed_metric.errors.full_messages.join('. ')}")
			return
		elsif observed_metric.nil?
			add_speech("I'm sorry, I don't know how to log information about #{params[:action]}.")
			return
		end

		observations = user.observations.where( 'started_at is not null' ).order( started_at: :desc )
		observations = observations.where( observed: observed_metric ) if observed_metric.present?
		observation  = observations.first
		# observation = user.observations.where( observed_type: 'Metric', observed: observed_metric ).where( 'started_at is not null' ).order( started_at: :asc ).last

		if observation.present?
			observation.stop!
			add_speech("Stopping your #{params[:action]} timer at #{observation.value.to_i} #{observation.unit}")
		else
			add_speech("I can't find any running #{params[:action]} timers.")
		end

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
			return
		end

		puts range

		calories = Observation.where( user: user, observed: Metric.where( user_id: user, title: 'ate' ), created_at: range ).sum(:value)

		add_speech("#{calories.to_i} calories.")

	end

	def stop

		add_speech("Stopping.")

	end

	private

	def get_user_metric( user, action, unit )

		if action.present?

			observed_metric = Metric.where( user_id: user ).find_by_alias( action.downcase )
			observed_metric ||= Metric.where( user_id: nil ).find_by_alias( action.downcase ).try(:dup)
			observed_metric ||= Metric.new( title: action, unit: unit ) if action.present?
			observed_metric.update( user: user ) if observed_metric.present?

		end

		observed_metric
	end

end
