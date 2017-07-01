
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
				assistant.conversation.state = "asking favorite color"

				assistant.ask(
					prompt: "What is your favorite color?",
					no_input_prompt: ["What did you say your favorite color is?"]
				)
			end

			assistant.intent.text do
				case assistant.arguments[0].text_value.downcase
				when "hello"
					tell_text = "Hi there!"
				when "goodbye"
					tell_text = "See you later!"
				else
					tell_text = "I heard you say #{assistant.arguments[0].text_value}, but I don't know what that means."
				end

				assistant.tell(tell_text)
			end
		end

		render json: assistant_response
	end

end
