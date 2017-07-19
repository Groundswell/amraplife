class LifemeterController < ApplicationController
	
	before_filter :authenticate_user!
	
	layout 'dash'


	def index
		@day = ( params[:day].present? && params[:day].to_datetime ) || Time.zone.now

		@inputs = current_user.user_inputs.order( created_at: :desc ).page( params[:page] )

		@metrics = current_user.metrics

		@timers = current_user.observations.where.not( started_at: nil ).where( value: nil )
	end

end