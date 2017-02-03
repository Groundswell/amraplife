
class ObservationsController < ApplicationController

	def index
		@observations = Observation.all
	end

	def show
		@observation = Observation.find( params[:id] )
	end

end