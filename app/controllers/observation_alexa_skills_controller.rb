
class ObservationAlexaSkillsController < ActionController::Base
	protect_from_forgery :except => [:create]
	before_filter :verify_alexa_authenticity, only: [:create], if: "Rails.env.production?"

	DEFAULT_DIALOG = {

		help: "To log fitness information just say \"Alexa tell Life Meter I ate one hundred calories\", or use a fitness timer by saying \"Alexa ask Life Meter to start a workout timer\".  Life Meter will remember, report and provide insights into what you have told it.",
		launch_user: "Welcome to Life Meter.  To log fitness information just say \"Alexa tell Life Meter I ate one hundred calories\", or use a fitness timer by saying \"Alexa ask Life Meter to start a workout timer\". Life Meter will remember, report and provide insights into what you have told it.",
		launch_guest: "Welcome to Life Meter.  To log fitness information just say \"Alexa tell Life Meter I ate one hundred calories\", or use a fitness timer by saying \"Alexa ask Life Meter to start a workout timer\".  Life Meter will remember, report and provide insights into what you have told it.  To get started open your Alexa app, and complete Life Meter registration.",

		login: "Open your Alexa app, and complete the Life Meter registration to continue",
	}

	def create

		puts request.raw_post
		json_post = JSON.parse(request.raw_post)
		json_post['version'] ||= 1 #bug, AlexaRubykit requires a version which is no longer provided?



		if json_post['context'].present? && json_post['context']["AudioPlayer"].present?
			@alexa_audio_player = { offset: json_post['context']["AudioPlayer"]['offsetInMilliseconds'], state: json_post['context']["AudioPlayer"]['playerActivity'].downcase, token: json_post['context']["AudioPlayer"]['token'] }
		end

		if ( json_post['session'].present? && ( request_user = json_post['session']['user'] ).present? ) || ( request_user = json_post['context']['System']['user'] ).present?

			@alexa_user = SwellMedia::OauthCredential.where( token: request_user['accessToken'], provider: 'amazon:alexa' ).first.try(:user) if request_user['accessToken'].present?
			@alexa_user ||= User.friendly.find( ENV['TEST_USER_APP_USER_ID'] ) if ENV['TEST_USER_APP_USER_ID'].present? && ENV['TEST_USER_ALEXA_USER_ID'].present? && ENV['TEST_USER_ALEXA_USER_ID'] == request_user['userId']


		end

		@alexa_response	= AlexaResponse.new

		if json_post['context'].present?
			@bot_session = BotSession.find_or_initialize_for( provider: "amazon:alexa", uid: json_post['context']["System"]['device']['deviceId'], user: @alexa_user )
		elsif json_post['session']
			@bot_session = BotSession.find_or_initialize_for( provider: "amazon:alexa", uid: json_post['session']['sessionId'], user: @alexa_user )
		end
		@alexa_user ||= @bot_session.user


		if not( json_post['request']['type'].start_with?('AudioPlayer.') )
			@alexa_request	= AlexaRubykit.build_request( json_post )
			@alexa_session	= @alexa_request.session
			@alexa_params 	= {}
			@alexa_params	= Hash[*@alexa_request.slots.values.collect{|values| [values['name'].to_sym,values['value']]}.flatten] if @alexa_request.respond_to?(:slots) && @alexa_request.slots.present?


			begin

				@bot_service = LifeMeterBotService.new( request: @alexa_request, response: self, session: @bot_session, audio_player: @alexa_audio_player, params: @alexa_params, user: @alexa_user, dialog: DEFAULT_DIALOG, source: 'alexa' )


				if (@alexa_request.type == 'SESSION_ENDED_REQUEST')
					# Wrap up whatever we need to do.
					puts "#{@alexa_request.type}"
					puts "#{@alexa_request.reason}"
					# halt 200

				elsif @alexa_request.type == 'LAUNCH_REQUEST'

					@bot_service.call_intent( :launch )

				elsif @alexa_request.type == 'INTENT_REQUEST'
					# Process your Intent Request

					action = @alexa_request.name.gsub('AMAZON.','').underscore.gsub('_intent','')

					unless @bot_service.call_intent( action )

						add_speech("Recieved Intent #{@alexa_request.name}")

					end
				end

			rescue Exception => e
				raise e if Rails.env.development?

				NewRelic::Agent.notice_error(e)
				add_speech("I'm sorry, I didn't understand that.")


			end

		else

			@alexa_params = json_post['request'].symbolize_keys
			@alexa_params[:offset] = @alexa_params.delete(:offsetInMilliseconds)
			@alexa_params[:event] = @alexa_params.delete(:type)

			@bot_service = LifeMeterBotService.new( response: self, session: @bot_session, audio_player: @alexa_audio_player, params: @alexa_params, user: @alexa_user, dialog: DEFAULT_DIALOG, source: 'alexa' )

			@bot_service.audio_event

		end

		@bot_session.save_if_used

		response_json = @alexa_response.build_response( !!!@ask_response )
		puts response_json

		render json: response_json
	end

	def login
		if current_user.present?
			login_success
			return
		end

		redirect_uri = params[:redirect_uri]
		session[:oauth_uri] = login_success_observation_alexa_skills_url( client_id: params[:client_id], state: params[:state], redirect_uri: redirect_uri )

		redirect_to main_app.lifemeter_index_path()
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

	def add_audio_url( url, args = {} )
		args[:offset] ||= 0
		args[:token] ||= SecureRandom.hex(10)
		play_behavior = "ENQUEUE" if args[:enqueue]
		@alexa_response.add_audio_url( url, args[:token], args[:offset], play_behavior, args[:enqueue] )
	end

	def add_card(type = nil, title = nil , subtitle = nil, content = nil)
		@alexa_response.add_card(type, title , subtitle, content)
	end

	def add_clear_audio_queue( args = {} )
		@alexa_response.add_clear_audio_queue(args)
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

	def add_stop_audio()
		@alexa_response.add_stop_audio()
	end

	private

	def verify_alexa_authenticity

		verifier = AlexaVerifier.build do |c|
		  c.verify_signatures = true
		  c.verify_timestamps = true
		  c.timestamp_tolerance = 60 # seconds
		end

		begin

			request_verified = verifier.verify!(
				request.headers['SignatureCertChainUrl'],
				request.headers['Signature'],
				request.body.read
			)

		rescue AlexaVerifier::VerificationError => ve
			puts ve.message
			NewRelic::Agent.notice_error(ve)

			render( :text => '400 Bad Request', :status => 400)
		end

		return request_verified
	end

end

class AlexaResponse < AlexaRubykit::Response
	def add_audio_url(url, token='', offset=0, play_behavior = nil, expectedPreviousToken = nil)
		directive = {
			'type' => 'AudioPlayer.Play',
			'playBehavior' => play_behavior || 'REPLACE_ALL',
			'audioItem' => {
				'stream' => {
					'token' => token,
					'url' => url,
					'offsetInMilliseconds' => offset
				}
			}
		}

		directive['audioItem']['stream']['expectedPreviousToken'] = expectedPreviousToken if expectedPreviousToken.present?

		@directives << directive
	end

	def add_stop_audio
		@directives << {
			'type' => 'AudioPlayer.Stop'
		}
	end

	def add_clear_audio_queue( args = {} )

		clear_behaviour = 'CLEAR_ALL'
		clear_behaviour = 'CLEAR_ENQUEUED' if args[:clear].present? && args[:clear].to_s == 'queue'

		@directives << {
			'type' => 'AudioPlayer.ClearQueue',
			'clearBehavior' => clear_behaviour,
		}
	end

end
