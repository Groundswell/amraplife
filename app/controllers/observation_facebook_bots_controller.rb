
class ObservationFacebookBotsController < ActionController::Base
	protect_from_forgery :except => [:create]

	def create
		puts request.raw_post
		if params['hub.challenge'] && ENV['FACEBOOK_LIFEMETER_BOT_VERIFICATION_TOKEN'] == params['hub.verify_token']
			render text: params['hub.challenge'], content_type: 'text/plain'
			return
		end

		if params[:object] == 'page'

			@user = SwellMedia::OauthCredential.where( uid: params[:event][:user], provider: "chat.facebook" ).first.try(:user)

			@bot_service = ObservationBotService.new( response: self, user: @user, params: {} )


			params[:entry].each do |entry|
				entry[:messaging].each do |messaging|
					@messaging = messaging
					
					unless @bot_service.respond_to_text messaging[:message][:text]

						chat_post_message( "Sorry, I don't know about that." )

					end
				end
			end

		end

		render text: 'OK', content_type: 'text/plain'
	end

	def login
		if current_user.present?
			login_success
			return
		end

		session[:dest] = login_success_observation_facebook_bots_url( team_id: params[:team_id], user: params[:user], token: params[:token] )

		redirect_to main_app.register_path()
	end

	def login_success
		oauth_credential = current_user.oauth_credentials.where( provider: "chat.facebook", uid: params[:user] ).first_or_initialize
		oauth_credential.save

		set_flash( 'Registration complete.  Now start logging!' )
		redirect_to '/'
	end

	def add_ask(speech_text, args = {} )
		puts "add_ask: #{speech_text}"
		chat_post_message( speech_text )
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
		chat_post_message( main_app.login_observation_facebook_bots_url( user: @messaging[:sender][:id], token: 'D4G5K' ) )
	end

	def add_reprompt(speech_text, ssml = false)
		puts "add_reprompt: #{speech_text}"
	end

	def add_speech(speech_text, ssml = false)
		puts "add_speech: #{speech_text}"
		if ssml
			chat_post_message( ActionController::Base.helpers.sanitize( speech_text ) )
		else
			chat_post_message( speech_text )
		end
	end

	def add_session_attribute( key, value )
		puts "add_session_attribute: #{key} -> #{value}"
	end

	private
	def chat_post_message( text, args = {} )


		query_headers = {
			content_type: :json,
		}

		query_body = {
			recipient: {
				id: args[:recipientId] || @messaging[:sender][:id]
			},
			message: {
				text: text
			}
		}

		api_endpoint = 'https://graph.facebook.com/v2.6/me/messages?access_token='+URI.encode( ENV['FACEBOOK_LIFEMETER_BOT_ACCESS_TOKEN'] )

		json_string_response = RestClient.post( api_endpoint, query_body.to_json, query_headers )
		puts json_string_response

		true
	end

end
