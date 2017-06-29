class DashController < ApplicationController
	
	before_filter :authenticate_user!
	
	layout 'dash'


	def index
		@day = ( params[:day].present? && params[:day].to_datetime ) || Time.zone.now

		@metrics = current_user.metrics
		@observations = current_user.observations.order( recorded_at: :desc ).page( params[:page] )
		@timers = current_user.observations.where.not( started_at: nil ).where( value: nil )
	end

end