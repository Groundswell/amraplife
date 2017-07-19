
class ObservationAlexaSkillsController < ActionController::Base
	protect_from_forgery :except => [:create]

	DEFAULT_DIALOG = {
		help: "To log fitness information just say \"Alexa tell AMRAP Life I ate 100 calories\", or use a fitness timer by saying \"Alexa ask AMRAP Life to start run timer\".  AMRAP Life will remember, report and provide insights into what you have told it.",
		launch_user: "Welcome to AMRAP Life.  To log fitness information just say \"Alexa tell AMRAP Life I ate 100 calories\", or use a fitness timer by saying \"Alexa ask AMRAP Life to start run timer\".  AMRAP Life will remember, report and provide insights into what you have hold it.",
		launch_guest: "Welcome to AMRAP Life.  To log fitness information just say \"Alexa tell AMRAP Life I ate 100 calories\", or use a fitness timer by saying \"Alexa ask AMRAP Life to start run timer\".  AMRAP Life will remember, report and provide insights into what you have hold it.  To get started open your Alexa app, and complete the AMRAP Life registration.",
		login: "Open your Alexa app, and complete the AMRAP Life registration to continue",
	}

	def create
		# @todo Check that it's a valid Alexa request
		json_post = JSON.parse(request.raw_post)
		json_post['version'] ||= 1 #bug, AlexaRubykit requires a version which is no longer provided?

		@alexa_request	= AlexaRubykit.build_request( json_post )
		@alexa_session	= @alexa_request.session
		@alexa_response	= AlexaRubykit::Response.new
		@alexa_params 	= {}
		@alexa_params	= Hash[*@alexa_request.slots.values.collect{|values| [values['name'].to_sym,values['value']]}.flatten] if @alexa_request.respond_to?(:slots) && @alexa_request.slots.present?

		@alexa_user = User.where( authorization_code: @alexa_session.access_token ).first if @alexa_session.access_token.present?
		@alexa_user ||= SwellMedia::OauthCredential.where( token: @alexa_session.access_token, provider: 'amazon:alexa' ).first.try(:user) if @alexa_session.access_token.present?

		@bot_service = ObservationBotService.new( request: @alexa_request, response: self, session: @alexa_session, params: @alexa_params, user: @alexa_user, dialog: DEFAULT_DIALOG, source: 'alexa' )

		if (@alexa_request.type == 'SESSION_ENDED_REQUEST')
			# Wrap up whatever we need to do.
			puts "#{@alexa_request.type}"
			puts "#{@alexa_request.reason}"
			# halt 200

		elsif @alexa_request.type == 'LAUNCH_REQUEST'

			@bot_service.launch()

		elsif @alexa_request.type == 'INTENT_REQUEST'
			# Process your Intent Request

			action = @alexa_request.name.gsub('AMAZON.','').underscore.gsub('_intent','')


			if @bot_service.respond_to?( action )

				@bot_service.send( action )

			else

				add_speech("Recieved Intent #{@alexa_request.name}")

			end
		end

		render json: @alexa_response.build_response( !!!@ask_response )
	end

	def login
		if current_user.present?
			login_success
			return
		end

		redirect_uri = params[:redirect_uri]
		session[:dest] = login_success_observation_alexa_skills_url( client_id: params[:client_id], state: params[:state], redirect_uri: redirect_uri )

		redirect_to main_app.register_path()
	end

	def login_success
		valid_redirect_urls = [
			'https://layla.amazon.com/spa/skill/account-linking-status.html?vendorId=MKT7E8U3IKMHM',
			'https://pitangui.amazon.com/spa/skill/account-linking-status.html?vendorId=MKT7E8U3IKMHM',
			'https://layla.amazon.com/spa/skill/account-linking-status.html?vendorId=M1F4UU7I5YESCS',
			'https://pitangui.amazon.com/spa/skill/account-linking-status.html?vendorId=M1F4UU7I5YESCS'
		]

		redirect_uri = params[:redirect_uri]

		if valid_redirect_urls.include?( redirect_uri )
			oauth_credential = current_user.oauth_credentials.where( provider: 'amazon:alexa' ).first_or_initialize
			oauth_credential.update( token: "#{current_user.name || current_user.id}-#{SecureRandom.hex(64)}" ) if oauth_credential.token.blank?

			redirect_uri = redirect_uri+"#"+{ state: params[:state], access_token: oauth_credential.token, token_type: "Bearer" }.to_query

			redirect_to redirect_uri
		else
			redirect_to '/'
		end
	end

	def add_ask(speech_text, args = {} )
		@ask_response = true
		alexa_response.add_speech( speech_text, !!(args[:ssml] || args[:speech_ssml]) )
		alexa_response.add_reprompt( args[:reprompt_text], !!(args[:ssml] || args[:speech_ssml]) ) if args[:reprompt_text].present?
	end

	def add_audio_url( url, token='', offset=0)
		@alexa_response.add_audio_url( url, token, offset )
	end

	def add_card(type = nil, title = nil , subtitle = nil, content = nil)
		@alexa_response.add_card(type, title , subtitle, content)
	end

	def add_hash_card( card )
		@alexa_response.add_hash_card( card )
	end

	def add_login_prompt( title = nil , subtitle = nil, content = nil )
		add_card('LinkAccount', title, subtitle, content )
	end

	def add_reprompt(speech_text, ssml = false)
		@alexa_response.add_reprompt( speech_text, ssml )
	end

	def add_speech(speech_text, ssml = false)
		@alexa_response.add_speech( speech_text, ssml )
	end

	def add_session_attribute( key, value )
		@alexa_response.add_session_attribute( key, value )
	end

end
