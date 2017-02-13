
class OptinsController < ApplicationController

	def create
		@optin = Optin.new( optin_params )
		if @optin.save
			redirect_to success_optin_path( @optin )
		else
			set_flash "Couldn't register", :error, @optin
			redirect_to :back
			return false
		end
	end



	private
		def optin_params
			params.require( :optin ).permit( :name, :email, :subject, :message )
		end
end