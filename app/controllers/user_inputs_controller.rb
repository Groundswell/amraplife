
class UserInputsController < ApplicationController
	before_filter :authenticate_user!

	# web interface posts here for user all commands
	def create
		@input = current_user.user_inputs.create( user_input_params )
		@input.parse_content!
		redirect_to :back
	end

	private
		def user_input_params
			params.require( :user_input ).permit( :content )
		end
end