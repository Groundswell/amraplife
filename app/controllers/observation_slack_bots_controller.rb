
class ObservationSlackBotsController < ActionController::Base
	protect_from_forgery :except => [:create]

	def create
		puts request.raw_post

		if params[:type] == 'url_verification'
			render text: params[:challenge], content_type: 'text/plain'
			return
		end

		render text: 'NOPE', content_type: 'text/plain'
	end

	def add_ask(speech_text, args = {} )

	end

	def add_audio_url( url, token='', offset=0)

	end

	def add_card(type = nil, title = nil , subtitle = nil, content = nil)

	end

	def add_hash_card( card )

	end

	def add_login_prompt( title = nil , subtitle = nil, content = nil )

	end

	def add_reprompt(speech_text, ssml = false)

	end

	def add_speech(speech_text, ssml = false)

	end

	def add_session_attribute( key, value )

	end

end
