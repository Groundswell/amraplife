class LifeMeterBotService < AbstractBotService

	add_intents( {
		define: {
			utterances: [
				'(?:to)?\s*def(?:ine)?\s*{term}',
			],
			slots: {
				term: 'Notes',
			}
		},
		get_motivation: {
			utterances: [
				'(?:to )?\s*(inspire |motivate )\s*me',
				'(?:to )?\s*(?:for )?\s*(?:give me )?\s*(inspiration|motivation)'
			 ],
			slots: {}
		},
		help: {
			utterances: [ 'help', 'for help' ]
		},
		launch: {
			utterances: [ '' ]
		},
		login: {
			utterances: [ 'login', 'sign me in', 'sign in', 'log in', 'log me in' ]
		},
	} )

	mount_intents :greetings_bot_service
	mount_intents :workout_bot_service
	mount_intents :observation_bot_service

	add_slots( {
		Notes: {
			regex: [
				'.+\z'
				],
				values: []
		},
  	} )


	def define
		#term = Term.published.find_by_alias( params[:term] )
		match = params[:term].downcase.singularize.gsub( /\s+/, '' )
		term = Term.published.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match ).first
		term = Term.published.find_by_alias( match ) if term.nil?

		if term.nil?
			# try the movement DB
			term = Movement.published.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match ).first
			term = Movement.published.find_by_alias( match ) if term.nil?
		end

		if term.present?
			if term.aliases.include?( params[:term] )
				response = "#{params[:term]} is an alias for #{term.title} which means: #{term.sanitized_content}"
			else
				response = "#{term.title} means: #{term.sanitized_content}"
			end
			add_speech( response )
			user.user_inputs.create( content: raw_input, result_obj: term, action: 'read', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{response}.'" ) if user.present?
		else
			add_speech( "Hmmm, I don't know about #{params[:term]} yet." )
			user.user_inputs.create( content: raw_input, action: 'read', source: options[:source], result_status: 'failed', system_notes: "Spoke: 'Hmmm, I don't know about #{params[:term]} yet.'" ) if user.present?
		end
	end

	def get_motivation

		motivation = Inspiration.published.order('random()').first

		add_speech( ActionController::Base.helpers.strip_tags( motivation.description ) )

		user.user_inputs.create( content: raw_input, result_obj: motivation, action: 'read', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{motivation.description}'" ) if user.present?

	end

	def help

		help_message = get_dialog('help', default: "To log information just say \"I ate one hundred calories\", or use a fitness timer by saying \"start a workout timer\". Life Meter will remember, report and provide insights into what you have told it.")

		add_speech( help_message )

		user.user_inputs.create( content: raw_input, action: 'read', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{help_message}'" ) if user.present?

	end

	def launch
		# Process your Launch Request
		if user.present?
			launch_message = get_dialog('launch_user', default: "Welcome to Life Meter by Life Meter. To log information just say \"I ate one hundred calories\", or use a fitness timer by saying \"start run timer\".  Life Meter will remember, report and provide insights into what you have told it.")

			add_ask(launch_message, reprompt_text: 'I\'m sorry, I couldn\'t hear you.  Try saying that again.' )
		else
			launch_message = get_dialog('launch_guest', default: "Welcome to Life Meter by Life Meter. To log fitness information just say \"I ate one hundred calories\", or use a fitness timer by saying \"start run timer\". Life Meter will remember, report and provide insights into what you have told it. To get started click this link, and complete the Life Meter skill registration.")

			add_speech(launch_message)
			add_login_prompt('Create your Life Meter Account', '', 'In order to record and report your metrics you must first create an account.')
		end
		# add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )
	end

	def login
		launch_message = get_dialog('login', default: "Click this link to complete the Life Meter skill registration")

		add_speech( launch_message )
		add_login_prompt('Create your Life Meter Account', '', 'In order to record and report your metrics you must first create an account.')

	end

end
