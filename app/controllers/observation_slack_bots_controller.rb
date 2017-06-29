
class ObservationSlackBotsController < ActionController::Base
	protect_from_forgery :except => [:create]

	def create
		puts request.raw_post

		if params[:type] == 'url_verification'
			render text: params[:challenge], content_type: 'text/plain'
			return
		end

		if params[:event].present? && params[:event][:type] == 'message' && ENV['SLACK_FITLOG_BOT_VERIFICATION_TOKEN'] == params[:token]

			@team = Team.where( slack_team_id: params[:team_id] )

			@bot_service = ObservationBotService.new( response: self, params: { event: params[:event] } )

			unless @bot_service.respond_to_text( params[:event][:text] )
				add_speech( "Sorry, I don't know about that." )
			end

			render text: 'OK', content_type: 'text/plain'
			return

		end

		render text: 'NOPE', content_type: 'text/plain'
	end

	def install_callback

		code = params[:code]
		state = params[:state]

		puts "auth_callback.code #{code} #{state}"
		puts "params.to_json #{params.to_json}"

		oauth_access_response = JSON.parse( RestClient.post( 'https://slack.com/api/oauth.access', { code: code, client_id: ENV['SLACK_FITLOG_BOT_CLIENT_ID'], client_secret: ENV['SLACK_FITLOG_BOT_CLIENT_SECRET'] } ), :symbolize_names => true )
		puts "oauth_access_response.to_json #{oauth_access_response.to_json}"

		auth_test_response = JSON.parse( RestClient.post( 'https://slack.com/api/auth.test', { token: oauth_access_response[:access_token] } ), :symbolize_names => true )
		puts "auth_test_response.to_json #{auth_test_response.to_json}"

		team_name = oauth_access_response[:team_name] || auth_test_response[:team_name]
		team_id = auth_test_response[:team_id] || oauth_access_response[:team_id]
		bot_user_id = ( oauth_access_response[:bot].present? ? oauth_access_response[:bot][:bot_user_id] : nil ) || ( auth_test_response[:bot].present? ? auth_test_response[:bot][:bot_user_id] : nil )
		bot_access_token = ( oauth_access_response[:bot].present? ? oauth_access_response[:bot][:bot_access_token] : nil ) || ( auth_test_response[:bot].present? ? auth_test_response[:bot][:bot_access_token] : nil )

		puts "team_name #{team_name}, team_id #{team_id}"

		@team = Team.find_by( slack_team_id: params[:team_id] )
		@team ||= Team.create(
			name: team_name,
			slack_team_id: team_id,
			properties: {
				'oauth_access_response' => oauth_access_response.to_json,
				'auth_test_response' => auth_test_response.to_json,
				'bot_user_id' => bot_user_id,
				'bot_access_token' => bot_access_token,
			} )

		puts "@team.name #{@team.name}, @team.slack_team_id #{@team.slack_team_id}"

		redirect_to '/'

	end

	def add_ask(speech_text, args = {} )
		puts "add_ask: #{speech_text}"
		chat_post_message( speech_text, channel: params[:event][:channel] )
	end


	def add_audio_url( url, token='', offset=0)
		puts "add_audio_url: #{url}"
	end

	def add_card(type = nil, title = nil , subtitle = nil, content = nil)
		puts "add_card (#{type}): #{title} (#{subtitle}) - #{content}"
	end

	def add_hash_card( card )
		puts "add_hash_card: #{card}"
	end

	def add_login_prompt( title = nil , subtitle = nil, content = nil )
		puts "add_login_prompt: #{title} (#{subtitle}) #{content}"
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

	def add_session_attribute( key, value )
		puts "add_session_attribute: #{key} -> #{value}"
	end

	private
	def chat_post_message( text, args = {} )


		query_headers = {
			# content_type: "application/json; charset=utf-8",
		}

		query_body = {
			token: @team.properties['bot_access_token'],
			channel: args[:channel],
			text: text,
			username: 'FitLog',
			as_user: false,
		}

		api_endpoint = 'https://slack.com/api/chat.postMessage'

		json_string_response = RestClient.post( api_endpoint, query_body, query_headers )
		puts json_string_response

		true
	end

end
