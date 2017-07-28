class AbstractBotService

	NATURAL_LANGUAGE_NUMBERS_REGEX = "([0-9]+|one|two|three|four|five|six|seven|eight|nine|ten|even|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty|thirty|fourty|fifty|sixty|seventy|eighty|ninety|hundred|thousand|million|billion)+(\s*,?\s+([0-9]+|one|two|three|four|five|six|seven|eight|nine|ten|even|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty|thirty|fourty|fifty|sixty|seventy|eighty|ninety|hundred|thousand|million|billion)*)*"
	NUMERIC_NUMBERS_REGEX = "(?<!\S)(?=.)(0|([1-9](\d*|\d{0,2}(,\d{3})*)))?(\.\d*[0-9])?(?!\S)"
	NATURAL_LANGUAGE_TIME_REGEX = "((#{NATURAL_LANGUAGE_NUMBERS_REGEX})\s+hour(s)?)?\s*((#{NATURAL_LANGUAGE_NUMBERS_REGEX})\s+minute(s)?)?\s*((#{NATURAL_LANGUAGE_NUMBERS_REGEX})\s+(second|minute|hour)(s)?)"
	NUMERIC_TIME_REGEX = "[1-9]*[0-9]:[0-5][0-9](:[0-5][0-9])?"

	DEFAULT_SLOTS = {
		Number: {
			regex: [
				NATURAL_LANGUAGE_NUMBERS_REGEX,
				NUMERIC_NUMBERS_REGEX,
			],
			values: []
		},
		Time: {
			regex: [
				NATURAL_LANGUAGE_TIME_REGEX,
				NUMERIC_TIME_REGEX,
			],
			values: []
		},
		TimePeriod: {
			regex: [
				"today|yesterday|this\s+(week|month|year)|last\s+(day|week|month)|last\s+#{NATURAL_LANGUAGE_NUMBERS_REGEX}\s+(days|weeks|months)",
			],
			values: []
		},
		TimeUnit: {
			regex: [
				"(week|month|day|year|weeks|months|days|years)",
			],
			values: []
		},
		Amount: {
			regex: [
				NATURAL_LANGUAGE_NUMBERS_REGEX,
				NUMERIC_NUMBERS_REGEX,
				NATURAL_LANGUAGE_TIME_REGEX,
				NUMERIC_TIME_REGEX,
			],
			values: []
		}
	}

	DEFAULT_INTENTS = {}

	def initialize( args = {} )

		@request	= args[:request]
		@session	= args[:session]
		@response	= args[:response] || DefaultActionResponse.new
		@params 	= args[:params] || {}
		@user 		= args[:user]
		@dialog		= args[:dialog] || {}
		@options	= args
		@except_intents = (args[:except] || []).collect(&:to_sym)
		@audio_player = args[:audio_player] || { offset: 0, state: 'stopped', token: nil }

	end

	def respond_to_text( text, args = {} )
		text = text.strip
		@raw_input = text

		compiled_intents 		= self.class.compiled_intents
		compiled_public_intents = self.class.compiled_public_intents

		requested_intent_name = nil
		requested_intent_matches = nil

		# place expected intents first, before public intents
		intent_names = (@session.try(:expected_intents) || []).collect(&:to_sym) + compiled_public_intents.keys

		intent_names.each do |intent_name|
			intent = compiled_intents[intent_name]

			unless ( matches = intent[:regex].match( text ) ).nil? || @except_intents.include?(intent_name.to_sym)
				requested_intent_name = intent_name
				requested_intent_matches = matches
				break
			end
		end


		if requested_intent_name.present?
			requested_intent = compiled_intents[requested_intent_name.to_sym]

			@params ||= {}
			requested_intent_matches.names.each do |name|
				@params[name.to_sym] = requested_intent_matches[name]
			end

			self.send( requested_intent_name )
			return true
		else
			user.user_inputs.create( content: @raw_input, action: 'failed', source: options[:source], result_status: 'parse failure', system_notes: "I didn't understand '#{@raw_input}'" ) if user.present?
			return false
		end
	end

	def audio_player
		@audio_player
	end

	def options
		@options
	end

	def params
		@params
	end

	def raw_input=( text )
		@raw_input = text
	end

	def raw_input
		@raw_input
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

	def self.add_intents( intents )
		intents.each do |name, definition|
			add_intent( name, definition )
		end
	end

	def self.add_intent( name, definition )
		@intents ||= DEFAULT_INTENTS
		definition[:utterances].each_with_index do |utterance,index|
			definition[:utterances][index] = utterance.gsub(/\s+/,'\\s+')
		end
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

					if ( matches = utterance_regex.match(/\{[a-z][a-z0-9\-_]*\}/i) ).present?
						raise Exception.new( "ERROR unmatches slots!!! (intent_name: #{intent_name}, utterance: \"#{utterance}\"). #{matches[0]} in \"#{utterance_regex}\"" )
					end

					regex = regex + '|' if regex.present?
					regex = (regex || '') + utterance_regex
				end

				regex = '^(' + regex + ')$'
				@compiled_intents[intent_name] = intent.merge( regex: Regexp.new( regex, true ) )
			end

		end

		@compiled_intents

	end

	def self.compiled_public_intents

		unless @compiled_public_intents.present?

			@compiled_public_intents = {}

			self.compiled_intents.each do |intent_name, intent|

				@compiled_public_intents[intent_name] = @compiled_intents[intent_name] unless intent[:private]

			end

		end

		@compiled_public_intents
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


	def add_audio_url( url, args = {} )
		if response.to_s == 'puts'
			puts "add_audio_url: #{url}"
		else
			response.add_audio_url( url, args )
		end
	end

	def add_clear_audio_queue( args = {} )
		if response.to_s == 'puts'
			puts "add_clear_audio_queue: #{args}"
		else
			response.add_clear_audio_queue( args )
		end
	end

	def add_stop_audio()
		if response.to_s == 'puts'
			puts "add_stop_audio"
		else
			response.add_stop_audio()
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

	def add_session_property( key, value )
		@session.add_session_property( key, value )
	end

	def get_session_property( key )
		@session.get_session_property( key )
	end

	def get_dialog( key, args = {} )
		return @dialog[key.to_sym] || args[:default]
	end

end



class DefaultActionResponse

	def initialize( args = {} )
		@queue = []
	end

	def queue
		@queue
	end


	def add_ask(speech_text, args = {} )
		puts "add_ask: #{speech_text}"
		@queue << [ :ask, speech_text, args ]
	end

	def add_audio_url( url, args = {} )
		puts "add_audio_url: #{url}"
		@queue << [ :audio_url, url, args ]
	end

	def add_clear_audio_queue( args = {} )
		puts "add_clear_audio_queue: #{args.to_json}"
		@queue << [ :add_clear_audio_queue, args ]
	end

	def add_stop_audio()
		puts "add_stop_audio"
		@queue << [ :add_stop_audio ]
	end

	def add_card(type = nil, title = nil , subtitle = nil, content = nil)
		puts "add_card (#{type}): #{title} (#{subtitle}) - #{content}"
		@queue << [ :card, type, title, subtitle, content ]
	end

	def add_hash_card( card )
		puts "add_hash_card: #{card}"
		add_card( card[:type], card[:title], card[:subtitle], card[:content] )
	end

	def add_login_prompt( title = nil , subtitle = nil, content = nil )
		puts "add_login_prompt: #{title} (#{subtitle}) #{content}"
		add_card( :login_prompt, title, subtitle, content )
	end

	def add_reprompt(speech_text, ssml = false)
		puts "add_reprompt: #{speech_text}"
		@queue << [ :reprompt, speech_text, ssml ]
	end

	def add_speech(speech_text, ssml = false)
		puts "add_speech: #{speech_text}"
		@queue << [ :speech, speech_text ]
	end

end
