
class ObservationAlexaSkillsController < ActionController::Base
	protect_from_forgery :except => [:create]

	def cancel_intent

		add_speech("Cancelling")

	end

	def help_intent

		add_speech("To log fitness information just say \"Alexa tell AMRAP Life I ate 100 calories\", or use a fitness timer by saying \"Alexa ask AMRAP Life to start run timer\".  AMRAP Life will remember, report and provide insights into what you have hold it.")

	end

	def launch_request
		# Process your Launch Request
		if alexa_user.present?
			add_speech("Welcome #{alexa_user.try(:full_name)}, to the AMRAP Life skill.  To log fitness information just say \"Alexa tell AMRAP Life I ate 100 calories\", or use a fitness timer by saying \"Alexa ask AMRAP Life to start run timer\".  AMRAP Life will remember, report and provide insights into what you have hold it.")
		else
			add_speech("Welcome to the AMRAP Life skill.  To log fitness information just say \"Alexa tell AMRAP Life I ate 100 calories\", or use a fitness timer by saying \"Alexa ask AMRAP Life to start run timer\".  AMRAP Life will remember, report and provide insights into what you have hold it.  To get started open your Alexa app, and complete the AMRAPLife skill registration.")
			add_card('LinkAccount', 'Create your Fitness Account', 'AMRAPLife', 'In order to record and report your metrics you must first create an AMRAPLife account.')
		end
		# add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )

	end

	def login_intent

		add_speech("Open your Alexa app, and complete the AMRAPLife skill registration to continue")
		add_card('LinkAccount', 'Create your Fitness Account', 'AMRAPLife', 'In order to record and report your metrics you must first create an AMRAPLife account.')

	end

	def log_metric_observation_intent
		unless alexa_user.present?
			login_intent
			return
		end

		if alexa_params[:action].present?

			observed_metric = get_user_metric( alexa_user, alexa_params[:action], alexa_params[:unit] )

			if observed_metric.nil?

				add_speech("I'm sorry, I don't know how to log information about #{alexa_params[:action]}.")

			else

				Observation.create( user: alexa_user, observed: observed_metric, value: alexa_params[:value], unit: alexa_params[:unit], notes: "start #{alexa_params[:action]}" )

				add_speech("Logging that you #{alexa_params[:action]} #{alexa_params[:value]} #{alexa_params[:unit]}")

			end

		else

			Observation.create( user: alexa_user, value: alexa_params[:value], unit: alexa_params[:unit], notes: "start #{alexa_params[:action]}" )

			add_speech("Logging #{alexa_params[:value]} #{alexa_params[:unit]}")

		end

	end

	def log_start_observation_intent
		unless alexa_user.present?
			login_intent
			return
		end

		observed_metric = get_user_metric( alexa_user, alexa_params[:action], 'seconds' )

		if observed_metric.nil?
			add_speech("I'm sorry, I don't know how to log information about #{alexa_params[:action]}.")
			return
		end

		Observation.create( user: alexa_user, observed: observed_metric, started_at: Time.zone.now, notes: "start #{alexa_params[:action]}" )
		add_speech("Starting your #{alexa_params[:action]} timer")

	end

	def log_stop_observation_intent
		unless alexa_user.present?
			login_intent
			return
		end

		observed_metric = get_user_metric( alexa_user, alexa_params[:action], 'seconds' )

		if observed_metric.nil?
			add_speech("I'm sorry, I don't know how to log information about #{alexa_params[:action]}.")
			return
		end

		observations = alexa_user.observations.where( 'started_at is not null' ).order( started_at: :desc )
		observations = observations.where( observed: observed_metric ) if observed_metric.present?
		observation  = observations.first
		# observation = alexa_user.observations.where( observed_type: 'Metric', observed: observed_metric ).where( 'started_at is not null' ).order( started_at: :asc ).last

		if observation.present?
			observation.stop
			add_speech("Stopping your #{alexa_params[:action]} timer at #{observation.value.to_i} #{observation.unit}")
		else
			add_speech("I can't find any running #{alexa_params[:action]} timers.")
		end

	end

	def stop_intent

		add_speech("Stopping.")

	end

	# Alexa Request Routing Action *********************************************
	# **************************************************************************
	def create
		# @todo Check that it's a valid Alexa request
		@alexa_request	= AlexaRubykit.build_request( JSON.parse(request.raw_post) )
		@alexa_session	= @alexa_request.session
		@alexa_response	= AlexaRubykit::Response.new
		@alexa_params 	= {}
		@alexa_params	= Hash[*@alexa_request.slots.values.collect{|values| [values['name'].to_sym,values['value']]}.flatten] if @alexa_request.respond_to?(:slots) && @alexa_request.slots.present?

		@alexa_user = User.where( authorization_code: @alexa_session.access_token ).first if @alexa_session.access_token.present?

		puts request.raw_post

		if (@alexa_request.type == 'SESSION_ENDED_REQUEST')
			# Wrap up whatever we need to do.
			puts "#{@alexa_request.type}"
			puts "#{@alexa_request.reason}"
			# halt 200

		elsif alexa_request.type == 'LAUNCH_REQUEST'

			launch_request()

		elsif alexa_request.type == 'INTENT_REQUEST'
			# Process your Intent Request
			puts "#{alexa_request.slots}"
			puts "#{alexa_request.name}"

			if alexa_request.name == 'AMAZON.StopIntent'

				stop_intent()

			elsif alexa_request.name == 'AMAZON.Cancel'

				cancel_intent()

			elsif alexa_request.name == 'AMAZON.HelpIntent'

				help_intent()

			elsif alexa_request.name == 'LoginIntent'

				login_intent()

			elsif alexa_request.name == 'LogMetricObservationIntent'

				log_metric_observation_intent()

			elsif alexa_request.name == 'LogStartObservationIntent'

				log_start_observation_intent()

			elsif alexa_request.name == 'LogStopObservationIntent'

				log_stop_observation_intent()

			else

				add_speech("Recieved Intent #{@alexa_request.name}")

			end
		end

		render json: @alexa_response.build_response( !!!@ask_response )
	end

	def login
		redirect_uri = params[:redirect_uri]
		session[:dest] = login_success_observation_alexa_skills_url( client_id: params[:client_id], state: params[:state], redirect_uri: redirect_uri )

		redirect_to main_app.register_path()
	end

	def login_success
		valid_redirect_urls = [
			'https://layla.amazon.com/spa/skill/account-linking-status.html?vendorId=MKT7E8U3IKMHM',
			'https://pitangui.amazon.com/spa/skill/account-linking-status.html?vendorId=MKT7E8U3IKMHM'
		]

		redirect_uri = params[:redirect_uri]

		if valid_redirect_urls.include?( redirect_uri )
			current_user.update( authorization_code: current_user.authorization_code || "#{current_user.name || current_user.id}-#{SecureRandom.hex(64)}" )

			redirect_uri = redirect_uri+"#"+{ state: params[:state], access_token: current_user.authorization_code, token_type: "Bearer" }.to_query

			redirect_to redirect_uri
		else
			redirect_to '/'
		end
	end

	private

	def get_user_metric( user, action, unit )

		if action.present?

			observed_metric = Metric.where( user_id: user ).find_by_alias( alexa_params[:action].downcase )
			observed_metric ||= Metric.where( user_id: nil ).find_by_alias( alexa_params[:action].downcase ).try(:dup)
			# observed_metric ||= Metric.new( title: alexa_params[:action], unit: unit )
			observed_metric.update( user: user ) if observed_metric.present?

		end

		observed_metric
	end

	def alexa_user
		@alexa_user
	end

	def add_ask(speech_text, args = {} )
		@ask_response = true
		alexa_response.add_speech( speech_text, !!(args[:ssml] || args[:speech_ssml]) )
		alexa_response.add_reprompt( args[:reprompt_text], !!(args[:ssml] || args[:speech_ssml]) ) if args[:reprompt_text].present?
	end


	def add_audio_url( url, token='', offset=0)
		alexa_response.add_audio_url( url, token, offset )
	end

	def add_card(type = nil, title = nil , subtitle = nil, content = nil)
		alexa_response.add_card(type, title , subtitle, content)
	end

	def add_hash_card( card )
		alexa_response.add_hash_card( card )
	end

	def add_reprompt(speech_text, ssml = false)
		alexa_response.add_reprompt( speech_text, ssml )
	end

	def add_speech(speech_text, ssml = false)
		alexa_response.add_speech( speech_text, ssml )
	end

	def add_session_attribute( key, value )
		alexa_response.add_session_attribute( key, value )
	end

	def alexa_params
		@alexa_params
	end

	def alexa_request
		@alexa_request
	end

	def alexa_response
		@alexa_response
	end

	def alexa_session
		@alexa_session
	end
end
