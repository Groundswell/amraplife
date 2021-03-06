
class ObservationGoogleActionsController < ActionController::Base
	protect_from_forgery :except => [:create]

	DEFAULT_DIALOG = {
		help: "To log fitness information like calories or a run, simply say \"Ok Google, tell Life Meter I ate one hundred calories\" or \"Ok Google, tell Life Meter to log that I ran 100 meters\".  You can also use Life Meter to time and log your exercise.  For example you can start a timer for your run by saying \"Ok Google, tell Life Meter to start run timer\" and stop it by saying \"Ok Google, tell Life Meter to stop run timer\".  Life Meter will remember, report and provide insights into what you have told it.",
		launch_user: "Welcome to Life Meter.  To log fitness information like calories or a run, simply say \"Ok Google, tell Life Meter I ate one hundred calories\" or \"Ok Google, tell Life Meter to log that I ran 100 meters\".  You can also use Life Meter to time and log your exercise.  For example you can start a timer for your run by saying \"Ok Google, tell Life Meter to start run timer\" and stop it by saying \"Ok Google, tell Life Meter to stop run timer\".  Life Meter will remember, report and provide insights into what you have told it.",
		launch_guest: "Welcome to Life Meter.  To log fitness information like calories or a run, simply say \"Ok Google, tell Life Meter I ate one hundred calories\" or \"Ok Google, tell Life Meter to log that I ran 100 meters\".  You can also use Life Meter to time and log your exercise.  For example you can start a timer for your run by saying \"Ok Google, tell Life Meter to start run timer\" and stop it by saying \"Ok Google, tell Life Meter to stop run timer\".  Life Meter will remember, report and provide insights into what you have told it.  To get started open your Google app, and complete the Life Meter registration.",
		login: "Open your Google app, and complete the Life Meter registration to continue",
	}

	def create
		puts request.raw_post

		assistant_response = GoogleAssistant.respond_to(params, response) do |assistant|

			@user = SwellMedia::OauthCredential.where( token: assistant.user.access_token, provider: 'google.assistant' ).first.try(:user) if assistant.user.access_token.present?
			@bot_session = BotSession.find_or_initialize_for( provider: "google.assistant", uid: assistant.user.access_token, user: @user )

			assistant.intent.main do
				action_response = GoogleActionResponse.new
				@bot_service = LifeMeterBotService.new( response: action_response, session: @bot_session, user: @user, params: {}, dialog: DEFAULT_DIALOG, source: 'google_actions' )

				request_text = params[:inputs].first[:raw_inputs].first[:query]
				request_text = request_text.gsub(/^.* (lifemeter|life\s+meter|amraplife|amrap\s+life|am\s+wrap\s+life)/i, '').strip

				if request_text.blank?
					@bot_service.call_intent( :launch )
				else
					unless @bot_service.respond_to_text( request_text )
						action_response.add_speech( "Sorry, I don't know about that." )
					end
				end

				action_response.respond( assistant )
			end

			@bot_session.save_if_used
		end

		puts "assistant_response #{assistant_response}"

		render json: assistant_response
	end

	def login
		if current_user.present?
			login_success
			return
		end

		redirect_uri = params[:redirect_uri] || params[:return_url]
		session[:oauth_uri] = login_success_observation_google_actions_url( client_id: params[:client_id], state: params[:state], redirect_uri: redirect_uri )

		redirect_to main_app.lifemeter_index_path()
	end

	def login_success

		redirect_uri = params[:redirect_uri] || params[:return_url] || ''

		if redirect_uri.start_with?("https://oauth-redirect.googleusercontent.com/r/") #redirect_uri == "https://oauth-redirect.googleusercontent.com/r/#{ENV['GOOGLE_ASSISTANT_LIFEMETER_BOT_APP_ID']}"
			oauth_credential = current_user.oauth_credentials.where( provider: 'google.assistant' ).first_or_initialize
			oauth_credential.update( token: "#{current_user.name || current_user.id}-#{SecureRandom.hex(64)}" ) if oauth_credential.token.blank?

			redirect_uri = redirect_uri+"#"+{ state: params[:state], access_token: oauth_credential.token, token_type: "bearer" }.to_query

			redirect_to redirect_uri
		else
			redirect_to '/'
		end
	end

	private

end

class GoogleActionResponse

	def initialize( args = {} )
		@queue = []
	end

	def queue
		@queue
	end

	def respond( assistant )
		return assistant.send( *self.queue.first )
	end


	def add_ask(speech_text, args = {} )
		puts "add_ask: #{speech_text}"
		ask_args = { prompt: speech_text }
		ask_args[:no_input_prompt] = [ ask_args[:reprompt_text] ] if ask_args[:reprompt_text].present?
		@queue << [ :ask, ask_args ]
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
	end

	def add_reprompt(speech_text, ssml = false)
		puts "add_reprompt: #{speech_text}"
	end

	def add_speech(speech_text, ssml = false)
		puts "add_speech: #{speech_text}"
		@queue << [ :tell, speech_text ]
	end

end
