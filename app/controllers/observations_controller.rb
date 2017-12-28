
class ObservationsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :get_observation, except: [ :create, :index ]

	layout 'lifemeter'

	# def create

	# 	@observation = Observation.new_from_string( params[:observation][:content], user: current_user )
		
	# 	if @observation.save
	# 		set_flash "Observation recorded"
	# 	else
	# 		set_flash "Observation could not be saved", :danger, @observation
	# 	end
	# 	redirect_to :back
	# end

	def destroy
		@observation.destroy
		set_flash "Observation Deleted"
		redirect_to observations_path
	end

	def index
		@observations = current_user.observations.order( recorded_at: :desc ).page( params[:page] )
	end

	def stop
		@observation.stop!
		redirect_to :back
	end

	def update
		@observation.update( observation_params )

		redirect_to :back
	end


	private
		def get_observation
			@observation = current_user.observations.find( params[:id] )
		end

		def observation_params

			# todo
			params[:observation][:display_unit] = params[:observation][:display_unit].chomp('.').singularize
			
			val_to_store =  UnitService.new( val: params[:observation][:value], stored_unit: params[:observation][:unit], display_unit: params[:observation][:display_unit] ).convert_to_stored_value
			
			if val_to_store == @observation.value
				params[:observation].delete( :value )
			else
				params[:observation][:value] = val_to_store
			end

			params.require( :observation ).permit( :recorded_at, :started_at, :ended_at, :value, :unit, :display_unit, :notes )
		end

end