
class UserInputsController < ApplicationController
	before_filter :authenticate_user!

	# web interface posts here for user all commands
	def create

		@bot_session = BotSession.find_or_initialize_for( provider: "amraplife.dash", uid: current_user.id, user: current_user )


		@bot_service = ObservationBotService.new( user: current_user, session: @bot_session, source: 'dash', except: [ :workout_complete, :workout_start ] )

		unless @bot_service.respond_to_text( user_input_params[:content] )

			set_flash "Sorry, I didn't understand that."

		end

		@bot_session.save_if_used

		redirect_to :back
	end

	private
		def user_input_params
			params.require( :user_input ).permit( :content )
		end
end
