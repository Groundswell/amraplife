
class MetricsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :get_metric, except: [ :create, :index ]

	layout 'lifemeter'

	def create
		@metric = current_user.metrics.new( metric_params )
		
		if @metric.save
			set_flash "Metric recorded"
		else
			set_flash "Metric could not be saved", :danger, @metric
		end
		redirect_to :back
	end

	def destroy
		@metric.destroy
		set_flash "Metric Deleted"
		redirect_to metrics_path
	end

	def index
		@metrics = current_user.metrics
	end

	def update
		@metric.update( metric_params )

		
		if @metric.previous_changes.include?( :display_unit )
			@metric.observations.update_all( display_unit: @metric.display_unit )
		end

		if params[:metric][:reassign_to_metric_id].present?
			# sanity-check that this is a valid assigned metric for the user
			metric = current_user.metrics.find_by( id: params[:metric][:reassign_to_metric_id] )
			if metric.present?
				# reassign all observations
				@metric.observations.update_all( observed_id: metric.id, observed_type: metric.class.name )
				# destroy the old metric
				@metric.destroy
			end
			redirect_to metrics_path
			return false
		end

		set_flash 'Updated'
		
		redirect_to :back
	end


	private
		def get_metric
			@metric = current_user.metrics.friendly.find( params[:id] )
		end

		def metric_params

			params[:metric][:target] = UnitService.new( val: params[:metric][:target], unit: @metric.unit, disp_unit: @metric.display_unit, use_metric: current_user.use_metric ).convert_to_stored_value
			
			params.require( :metric ).permit( :title, :unit, :display_unit, :aliases_csv, :description, :target, :target_type, :target_period, :target_direction )
		end

end