
class ObservationFacebookBotsController < ActionController::Base
	protect_from_forgery :except => [:create]

	def create
		puts request.raw_post
		if params['hub.challenge'] && ENV['FACEBOOK_LIFEMETER_BOT_VERIFICATION_TOKEN'] == params['hub.verify_token']
			render text: params['hub.challenge'], content_type: 'text/plain'
			return
		end

		render text: 'OK', content_type: 'text/plain'
	end

	def login

	end

	def login_success

		set_flash( 'Registration complete.  Now start logging!' )
		redirect_to '/'
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

end
