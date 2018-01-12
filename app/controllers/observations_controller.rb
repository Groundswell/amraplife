
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

		@observation.status = observation_params[:status]
		@observation.started_at = observation_params[:started_at]
		@observation.ended_at = observation_params[:ended_at]
		@observation.recorded_at = observation_params[:recorded_at]

		if @observation.unit.is_time?
			val = observation_params[:value]
		else

			unit = observation_params[:value].strip.split( /\s+/ ).last.gsub( /\d+/, '' ).singularize
			val = observation_params[:value].strip.split( /\s+/ ).first.gsub( /[a-zA-Z]+/, '' )
		end


		if unit.present?
			stored_unit = Unit.find_by_alias( unit )
			@observation.unit = stored_unit if stored_unit.present?
		end

		@observation.unit ||= @observation.parent_obj.unit

		@observation.value = @observation.unit.convert_to_base( val )

		@observation.save

		redirect_to :back
	end


	private
		def get_observation
			@observation = current_user.observations.find( params[:id] )
		end

		def observation_params
			params.require( :observation ).permit( :status, :recorded_at, :started_at, :ended_at, :value, :notes )
		end

end