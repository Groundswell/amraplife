
class ObservationGoogleActionsController < ActionController::Base
	protect_from_forgery :except => [:create]

	DEFAULT_DIALOG = {
		help: "To log fitness information just say \"Google tell Life Meter I ate 100 calories\", or use a fitness timer by saying \"Google ask Life Meter to start run timer\".  Life Meter will remember, report and provide insights into what you have told it.",
		launch_user: "Welcome to Life Meter, an AMRAP Life skill.  To log fitness information just say \"Google tell Life Meter I ate 100 calories\", or use a fitness timer by saying \"Google ask Life Meter to start run timer\".  Life Meter will remember, report and provide insights into what you have hold it.",
		launch_guest: "Welcome to Life Meter, an AMRAP Life skill.  To log fitness information just say \"Google tell Life Meter I ate 100 calories\", or use a fitness timer by saying \"Google ask Life Meter to start run timer\".  Life Meter will remember, report and provide insights into what you have hold it.  To get started open your Google app, and complete the Life Meter skill registration on AMRAPLife.",
		login: "Open your Google app, and complete the Life Meter skill registration on AMRAP Life to continue",
	}

	def create
		puts request.raw_post

		assistant_response = GoogleAssistant.respond_to(params, response) do |assistant|

			assistant.intent.main do
				action_response = GoogleActionResponse.new( assistant: assistant )
				@bot_service = ObservationBotService.new( response: action_response, user: nil, params: {}, dialog: DEFAULT_DIALOG )
				@bot_service.respond_to_text( '' )

				action_response.respond( assistant )

			end

			assistant.intent.text do
				action_response = GoogleActionResponse.new( assistant: assistant )
				@bot_service = ObservationBotService.new( response: action_response, user: nil, params: {}, dialog: DEFAULT_DIALOG )

				request_text = assistant.arguments[0].text_value.downcase
				request_text = request_text.gsub(/^.* LifeMeter/, '')
				# puts request_text

				unless @bot_service.respond_to_text( request_text )
					action_response.add_speech( "Sorry, I don't know about that." )
				end

				action_response.respond( assistant )

			end
		end

		puts "assistant_response #{assistant_response}"

		render json: assistant_response
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

	def add_session_attribute( key, value )
		puts "add_session_attribute: #{key} -> #{value}"
	end

end
