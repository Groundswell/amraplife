class UserUnitsController < ApplicationController

	before_filter :authenticate_user!

	layout 'lifemeter'


	def index
		@units = current_user.units.page
	end

end