
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
		unit = Unit.find_by_alias( metric_params[:unit_alias] )
		
		@metric.update( metric_params )
		@metric.update( unit_id: unit.id ) if unit.present?

		if @metric.previous_changes.include?( :unit_id )
			@metric.observations.update_all( unit_id: @metric.unit_id )
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

		set_flash "Updated"
		set_flash "#{metric_params[:unit_alias]} is an unknown unit.", :warning if unit.nil?
		
		redirect_to :back
	end


	private
		def get_metric
			@metric = current_user.metrics.friendly.find( params[:id] )
		end

		def metric_params
			params.require( :metric ).permit( :title, :unit_alias, :aliases_csv, :description, :target, :target_type, :target_period, :target_direction )
		end

end