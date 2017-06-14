
class MetricsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :get_metric, except: [ :create, :index ]

	layout 'dash'

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
		set_flash 'Updated'
		redirect_to :back
	end


	private
		def get_metric
			@metric = current_user.metrics.friendly.find( params[:id] )
		end

		def metric_params
			params.require( :metric ).permit( :title, :unit, :aliases_csv, :description )
		end

end