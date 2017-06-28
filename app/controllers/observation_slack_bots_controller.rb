
class ObservationSlackBotsController < ActionController::Base
	protect_from_forgery :except => [:create]

	def create
		puts request.raw_post

		if params[:type] == 'url_verification'
			render text: params[:challenge], content_type: 'text/plain'
			return
		end

		if params[:event].present? && params[:event][:type] == 'message'


			@bot_service = ObservationBotService.new( response: self, params: { event: params[:event] } )
			
			unless @bot_service.respond_to_text( params[:event][:text] )
				add_speech( "Sorry, I don't know about that." )
			end

			render text: 'OK', content_type: 'text/plain'
			return

		end

		render text: 'NOPE', content_type: 'text/plain'
	end

	def add_ask(speech_text, args = {} )
		puts "add_ask: #{speech_text}"
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
	end

	def add_session_attribute( key, value )
		puts "add_session_attribute: #{key} -> #{value}"
	end

end
