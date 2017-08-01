class LifeMeterBotService < AbstractBotService

	add_intents( {
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
		}
	} )

	mount_intents :greetings_bot_service
	mount_intents :workout_bot_service
	mount_intents :observation_bot_service


	def get_motivation

		motivation = Inspiration.published.order('random()').first

		add_speech( ActionController::Base.helpers.strip_tags( motivation.description ) )

		user.user_inputs.create( content: raw_input, result_obj: motivation, action: 'read', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{motivation.description}'" ) if user.present?

	end

	def help

		help_message = get_dialog('help', default: "To log information just say \"I ate 100 calories\", or use a fitness timer by saying \"start a workout timer\". Life Meter will remember, report and provide insights into what you have told it.")

		add_speech( help_message )

		user.user_inputs.create( content: raw_input, action: 'read', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{help_message}'" ) if user.present?

	end

	def launch
		# Process your Launch Request
		if user.present?
			launch_message = get_dialog('launch_user', default: "Welcome to Life Meter by Life Meter. To log information just say \"I ate 100 calories\", or use a fitness timer by saying \"start run timer\".  Life Meter will remember, report and provide insights into what you have told it.")

			add_speech(launch_message)
		else
			launch_message = get_dialog('launch_guest', default: "Welcome to Life Meter by Life Meter. To log fitness information just say \"I ate 100 calories\", or use a fitness timer by saying \"start run timer\". Life Meter will remember, report and provide insights into what you have told it. To get started click this link, and complete the Life Meter skill registration on AMRAPLife.com.")

			add_speech(launch_message)
			add_login_prompt('Create your Life Meter Account on AMRAPLife.com', '', 'In order to record and report your metrics you must first create an account on AMRAPLife.com.')
		end
		# add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )

	end

	def login
		launch_message = get_dialog('login', default: "Click this link to complete the Life Meter skill registration on AMRAPLife.com")


		add_speech( launch_message )
		add_login_prompt('Create your Life Meter Account on AMRAPLife.com', '', 'In order to record and report your metrics you must first create an account on AMRAPLife.com.')

	end

end
