class AbstractBotService

	DEFAULT_SLOTS = {
		Number: {
			regex: [
				"(one|two|three|four|five|six|seven|eight|nine|ten|even|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty|thirty|fourty|fifty|sixty|seventy|eighty|ninety|hundred|thousand|million|billion)+(\s*,?\s+(one|two|three|four|five|six|seven|eight|nine|ten|even|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty|thirty|fourty|fifty|sixty|seventy|eighty|ninety|hundred|thousand|million|billion)*)*",
				"(?<!\S)(?=.)(0|([1-9](\d*|\d{0,2}(,\d{3})*)))?(\.\d*[0-9])?(?!\S)",
			],
			values: []
		}
	}

	DEFAULT_INTENTS = {}

	def initialize( args = {} )

		@request	= args[:request]
		@session	= args[:session]
		@response	= args[:response] || :puts
		@params 	= args[:params]
		@user 		= args[:user]

	end

	def respond_to_text( text, args = {} )
		compiled_intents = self.class.compiled_intents

		requested_intent_name = nil
		requested_intent_matches = nil

		compiled_intents.each do |intent_name, intent|
			unless ( matches = intent[:regex].match( text ) ).nil?
				requested_intent_name = intent_name
				requested_intent_matches = matches
				break
			end
		end

		puts requested_intent_name

		if requested_intent_name.present?
			requested_intent = compiled_intents[requested_intent_name.to_sym]

			@params ||= {}
			requested_intent_matches.names.each do |name|
				@params[name.to_sym] = requested_intent_matches[name]
			end

			self.send( requested_intent_name )
			return true
		else
			return false
		end
	end

	def self.add_intents( intents )
		intents.each do |name, definition|
			add_intent( name, definition )
		end
	end

	def self.add_intent( name, definition )
		@intents ||= DEFAULT_INTENTS
		@intents[name.to_sym] = definition
	end

	def self.add_slots( slots )
		slots.each do |name, definition|
			add_slot( name, definition )
		end
	end

	def self.add_slot( name, definition )
		@slots ||= DEFAULT_SLOTS
		@slots[name.to_sym] = definition
	end

	def self.compiled_intents

		unless @compiled_intents.present?
			@compiled_intents = {}

			self.intents.each do |intent_name,intent|
				regex = nil
				(intent[:utterances] || []).each do |utterance|
					utterance_regex = utterance
					(intent[:slots] || {}).each do |slot_name, slot_type|
						slot = slots[slot_type.to_sym]

						utterance_regex = utterance_regex.gsub("{#{slot_name}}","(?'#{slot_name}'#{slot[:regex].join('|')})")
					end
					regex = regex + '|' if regex.present?
					regex = (regex || '') + utterance_regex
				end

				regex = '/^' + regex + '$/i'
				@compiled_intents[intent_name] = intent.merge( regex: Regexp.new( regex ) )
			end

		end

		@compiled_intents

	end

	def self.intents
		@intents ||= DEFAULT_INTENTS
		@intents
	end

	def self.slots
		@slots ||= DEFAULT_SLOTS
		@slots
	end

	protected

	def user
		@user
	end

	def add_ask(speech_text, args = {} )
		if response.to_s == 'puts'
			puts "add_ask: #{speech_text}"
		else
			response.add_ask( speech_text, args )
		end
	end


	def add_audio_url( url, token='', offset=0)
		if response.to_s == 'puts'
			puts "add_audio_url: #{url}"
		else
			response.add_audio_url( url, token, offset )
		end
	end

	def add_card(type = nil, title = nil , subtitle = nil, content = nil)
		if response.to_s == 'puts'
			puts "add_card (#{type}): #{title} (#{subtitle}) - #{content}"
		else
			response.add_card(type, title , subtitle, content)
		end
	end

	def add_hash_card( card )
		if response.to_s == 'puts'
			puts "add_hash_card: #{card}"
		else
			response.add_hash_card( card )
		end
	end

	def add_login_prompt( title = nil , subtitle = nil, content = nil )
		if response.to_s == 'puts'
			puts "add_login_prompt: #{title} (#{subtitle}) #{content}"
		else
			response.add_login_prompt( title , subtitle, content )
		end
	end

	def add_reprompt(speech_text, ssml = false)
		if response.to_s == 'puts'
			puts "add_reprompt: #{speech_text}"
		else
			response.add_reprompt( speech_text, ssml )
		end
	end

	def add_speech(speech_text, ssml = false)
		if response.to_s == 'puts'
			puts "add_speech: #{speech_text}"
		else
			response.add_speech( speech_text, ssml )
		end
	end

	def add_session_attribute( key, value )
		if response.to_s == 'puts'
			puts "add_session_attribute: #{key} -> #{value}"
		else
			response.add_session_attribute( key, value )
		end
	end

	def params
		@params
	end

	def request
		@request
	end

	def response
		@response
	end

	def session
		@session
	end

end
