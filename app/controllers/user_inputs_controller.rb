
class UserInputsController < ApplicationController
	before_filter :authenticate_user!

	# web interface posts here for user all commands
	def create

		@bot_service = ObservationBotService.new( user: current_user, source: 'dash', except: [ :workout_complete, :workout_start ] )

		unless @bot_service.respond_to_text( user_input_params[:content] )

			set_flash "Sorry, I didn't understand that."

		end


		redirect_to :back
	end

	private
		def user_input_params
			params.require( :user_input ).permit( :content )
		end
end
