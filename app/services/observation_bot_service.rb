class ObservationBotService

	def initialize( args = {} )

		@request	= args[:request]
		@session	= args[:session]
		@response	= args[:response]
		@params 	= args[:params]
		@user 		= args[:user]

	end


	def cancel

		add_speech("Cancelling")

	end

	def help

		add_speech("To log fitness information just say \"Alexa tell Fit Log I ate 100 calories\", or use a fitness timer by saying \"Alexa ask Fit Log to start run timer\".  Fit Log will remember, report and provide insights into what you have told it.")

	end

	def launch
		# Process your Launch Request
		if user.present?
			add_speech("Welcome to Fit Log, an AMRAP Life skill.  To log fitness information just say \"Alexa tell Fit Log I ate 100 calories\", or use a fitness timer by saying \"Alexa ask Fit Log to start run timer\".  Fit Log will remember, report and provide insights into what you have hold it.")
		else
			add_speech("Welcome to Fit Log, an AMRAP Life skill.  To log fitness information just say \"Alexa tell Fit Log I ate 100 calories\", or use a fitness timer by saying \"Alexa ask Fit Log to start run timer\".  Fit Log will remember, report and provide insights into what you have hold it.  To get started open your Alexa app, and complete the Fit Log skill registration on AMRAPLife.")
			add_login_prompt('Create your Fit Log Account on AMRAPLife', '', 'In order to record and report your metrics you must first create a Fit Log account on AMRAPLife.')
		end
		# add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )

	end

	def login

		add_speech("Open your Alexa app, and complete the Fit Log skill registration on AMRAP Life to continue")
		add_login_prompt('Create your Fit Log Account on AMRAPLife', '', 'In order to record and report your metrics you must first create a Fit Log account on AMRAPLife.')

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

		if params[:action].present?

			observed_metric = get_user_metric( user, params[:action], params[:unit] )

			if observed_metric.nil?

				add_speech("I'm sorry, I don't know how to log information about #{params[:action]}.")

			else

				Observation.create( user: user, observed: observed_metric, value: params[:value], unit: params[:unit], notes: "start #{params[:action]}" )

				add_speech("Logging that you #{params[:action]} #{params[:value]} #{params[:unit]}")

			end

		else

			Observation.create( user: user, value: params[:value], unit: params[:unit], notes: "start #{params[:action]}" )

			add_speech("Logging #{params[:value]} #{params[:unit]}")

		end

	end

	def log_start_observation
		unless user.present?
			login
			return
		end

		observed_metric = get_user_metric( user, params[:action], 'seconds' )

		if observed_metric.nil?
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

		if observed_metric.nil?
			add_speech("I'm sorry, I don't know how to log information about #{params[:action]}.")
			return
		end

		observations = user.observations.where( 'started_at is not null' ).order( started_at: :desc )
		observations = observations.where( observed: observed_metric ) if observed_metric.present?
		observation  = observations.first
		# observation = user.observations.where( observed_type: 'Metric', observed: observed_metric ).where( 'started_at is not null' ).order( started_at: :asc ).last

		if observation.present?
			observation.stop
			add_speech("Stopping your #{params[:action]} timer at #{observation.value.to_i} #{observation.unit}")
		else
			add_speech("I can't find any running #{params[:action]} timers.")
		end

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

	def user
		@user
	end

	def add_ask(speech_text, args = {} )
		response.add_ask( speech_tex, args )
	end


	def add_audio_url( url, token='', offset=0)
		response.add_audio_url( url, token, offset )
	end

	def add_card(type = nil, title = nil , subtitle = nil, content = nil)
		response.add_card(type, title , subtitle, content)
	end

	def add_hash_card( card )
		response.add_hash_card( card )
	end

	def add_login_prompt( title = nil , subtitle = nil, content = nil )
		response.add_login_prompt( title , subtitle, content )
	end

	def add_reprompt(speech_text, ssml = false)
		response.add_reprompt( speech_text, ssml )
	end

	def add_speech(speech_text, ssml = false)
		response.add_speech( speech_text, ssml )
	end

	def add_session_attribute( key, value )
		response.add_session_attribute( key, value )
	end

	def params
		@params
	end

	def request
		@request
	end

	def response
		@response
	end

	def session
		@session
	end

end
