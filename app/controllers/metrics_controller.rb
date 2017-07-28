
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
		if not( current_user.use_metric_units? ) && Metric.imperial_units[@metric.unit] && params[:metric][:display_unit].blank?
			@metric.update( display_unit: Metric.imperial_units[@metric.unit] )
		end

		set_flash 'Updated'

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


		
		redirect_to :back
	end


	private
		def get_metric
			@metric = current_user.metrics.friendly.find( params[:id] )
		end

		def metric_params
			params[:metric][:unit] = params[:metric][:unit].singularize.chomp( '.' )

			params[:metric][:target] = ChronicDuration.parse( params[:metric][:target] ) if params[:metric][:target_type].match( /value/) && ChronicDuration.parse( params[:metric][:target] )
			
			params.require( :metric ).permit( :title, :unit, :display_unit, :aliases_csv, :description, :target, :target_type, :target_period, :target_direction )
		end

end