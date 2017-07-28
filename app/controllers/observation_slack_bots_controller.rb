
class ObservationSlackBotsController < ActionController::Base
	protect_from_forgery :except => [:create]

	def create
		puts request.raw_post

		if params[:type] == 'url_verification'
			render text: params[:challenge], content_type: 'text/plain'
			return
		end

		# only respond to message, and not to bots.
		if params[:event].present? && params[:event][:type] == 'message' && params[:event][:bot_id].blank? && ENV['SLACK_LIFEMETER_BOT_VERIFICATION_TOKEN'] == params[:token]

			@team = Team.find_by( slack_team_id: params[:team_id] )
			@user = SwellMedia::OauthCredential.where( uid: params[:event][:user], provider: "#{params[:team_id]}.slack" ).first.try(:user)
			@user ||= @team.team_users.find_by( slack_user_id: params[:event][:user] ).try(:user) if @team.present?
			@bot_session = BotSession.find_or_initialize_for( provider: "#{params[:team_id]}.slack", uid: params[:event][:user], user: @user )


			@bot_service = ObservationBotService.new( response: self, session: @bot_session, user: @user, params: { event: params[:event] }, source: 'slack', except: [ :workout_complete, :workout_start ] )

			unless @bot_service.respond_to_text( params[:event][:text] )
				add_speech( "Sorry, I don't know about that." )
			end

			@bot_session.save_if_used

			render text: 'OK', content_type: 'text/plain'
			return

		end

		render text: 'NOPE', content_type: 'text/plain'
	end

	def install_callback

		code = params[:code]
		state = params[:state]

		oauth_access_response = JSON.parse( RestClient.post( 'https://slack.com/api/oauth.access', { code: code, client_id: ENV['SLACK_LIFEMETER_BOT_CLIENT_ID'], client_secret: ENV['SLACK_LIFEMETER_BOT_CLIENT_SECRET'] } ), :symbolize_names => true )

		auth_test_response = JSON.parse( RestClient.post( 'https://slack.com/api/auth.test', { token: oauth_access_response[:access_token] } ), :symbolize_names => true )

		team_name = oauth_access_response[:team_name] || auth_test_response[:team_name]
		team_id = auth_test_response[:team_id] || oauth_access_response[:team_id]
		bot_user_id = ( oauth_access_response[:bot].present? ? oauth_access_response[:bot][:bot_user_id] : nil ) || ( auth_test_response[:bot].present? ? auth_test_response[:bot][:bot_user_id] : nil )
		bot_access_token = ( oauth_access_response[:bot].present? ? oauth_access_response[:bot][:bot_access_token] : nil ) || ( auth_test_response[:bot].present? ? auth_test_response[:bot][:bot_access_token] : nil )
		access_token = oauth_access_response[:access_token]

		@team = Team.find_by( slack_team_id: team_id )
		@team ||= Team.new( properties: {} )
		@team.update(
			name: team_name,
			slack_team_id: team_id,
			properties: @team.properties.merge({
				'oauth_access_response' => oauth_access_response.to_json,
				'auth_test_response' => auth_test_response.to_json,
				'bot_user_id' => bot_user_id,
				'bot_access_token' => bot_access_token,
				'access_token' => access_token,
			})
		)

		set_flash( 'Life Meter Slack Bot was Successfully Installed.' )
		redirect_to '/'

	end

	def login
		@team = Team.find_by( slack_team_id: params[:team_id] )
		unless @team.present?
			set_flash( 'Before registering, you must first install the AMRAP Life app on Slack.' )
			redirect_to '/'
		end

		if current_user.present?
			login_success
			return
		end

		session[:oauth_uri] = login_success_observation_slack_bots_url( team_id: params[:team_id], user: params[:user], token: params[:token] )

		redirect_to main_app.lifemeter_index_path()
	end

	def login_success
		@team = Team.find_by( slack_team_id: params[:team_id] )
		oauth_credential = current_user.oauth_credentials.where( provider: "#{@team.slack_team_id}.slack", uid: params[:user] ).first_or_initialize
		oauth_credential.save

		@team.team_users.where( user: current_user, slack_user_id: params[:user] ).first_or_create
		#oauth_credential.update( token: "#{current_user.name || current_user.id}-#{SecureRandom.hex(64)}" ) if oauth_credential.token.blank?
		set_flash( 'Registration complete.  Now start logging!' )
		redirect_to '/'
	end

	def add_ask(speech_text, args = {} )
		puts "add_ask: #{speech_text}"
		chat_post_message( speech_text, channel: params[:event][:channel] )
	end


	def add_audio_url( url, token='', offset=0)
		puts "add_audio_url: #{url}"
	end

	def add_clear_audio_queue( args = {} )
		puts "add_clear_audio_queue: #{args}"
	end

	def add_stop_audio()
		puts "add_stop_audio"
	end

	def add_card(type = nil, title = nil , subtitle = nil, content = nil)
		puts "add_card (#{type}): #{title} (#{subtitle}) - #{content}"
	end

	def add_hash_card( card )
		puts "add_hash_card: #{card}"
	end

	def add_login_prompt( title = nil , subtitle = nil, content = nil )
		puts "add_login_prompt: #{title} (#{subtitle}) #{content}"
		chat_post_message( main_app.login_observation_slack_bots_url( team_id: params[:team_id],  user: params[:event][:user], token: 'D4G5K' ), channel: params[:event][:channel] )
	end

	def add_reprompt(speech_text, ssml = false)
		puts "add_reprompt: #{speech_text}"
	end

	def add_speech(speech_text, ssml = false)
		puts "add_speech: #{speech_text}"
		if ssml
			chat_post_message( ActionController::Base.helpers.sanitize( speech_text ), channel: params[:event][:channel] )
		else
			chat_post_message( speech_text, channel: params[:event][:channel] )
		end
	end

	private
	def chat_post_message( text, args = {} )


		query_headers = {
			# content_type: "application/json; charset=utf-8",
		}

		query_body = args.merge({
			token: @team.properties['bot_access_token'],
			text: text,
			username: 'AMRAP Life',
			as_user: false,
		})

		api_endpoint = 'https://slack.com/api/chat.postMessage'

		json_string_response = RestClient.post( api_endpoint, query_body, query_headers )
		puts json_string_response

		true
	end

end
