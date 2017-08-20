class GreetingsBotService < AbstractBotService

	add_intents( {
		hello: {
			utterances: [ 'hi', 'hey', 'yo', 'hello', 'hi there', 'good morning', 'good afternoon' ]
		},
   		set_name: {
   			utterances: [
   				'(?:to )?\s*call me {name}',
   				'(?:that )?\s*my name is {name}'
   				],
   			slots:{
   				name: 'Name',
   			},
   		},
	} )


	add_slots( {
		Name: {
			regex: [
				'.+'
			],
			values: []
		},
	})

	def hello
		greetings = [
			'Howdy',
			'Whasssup',
			'Hey Hey',
			'Greetings',
			'Hi there'
		]

		if user.present?
			 message = "#{greetings.sample}, #{user}"
		else
			 message = "#{greetings.sample}"
		end

		add_speech( message )

		user.user_inputs.create( content: raw_input, action: 'read', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{message}'" ) if user.present?

	end

	def set_name
		unless user.present?
			call_intent( :login )
			return
		end

		unless params[:name].present?
			add_ask("Can you please repeat that. I didn't catch your name.")
			return
		end

		user.update( first_name: params[:name] )
		add_speech("OK, from now on I'll call you #{params[:name]}.")
		user.user_inputs.create( content: raw_input, result_obj: user, action: 'updated', source: options[:source], result_status: 'success', system_notes: "Spoke: 'OK, from now on I'll call you #{params[:name]}.'" )
	end

end
