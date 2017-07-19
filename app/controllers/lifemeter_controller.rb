class LifemeterController < ApplicationController
	
	before_filter :authenticate_user!, only: :dash

	def dash

		@day = ( params[:day].present? && params[:day].to_datetime ) || Time.zone.now

		@inputs = current_user.user_inputs.order( created_at: :desc ).page( params[:page] )

		@metrics = current_user.metrics

		@timers = current_user.observations.where.not( started_at: nil ).where( value: nil )
		render layout: 'lifemeter'
	end

	def index
		if current_user
			redirect_to dash_lifemeter_index_path
			return false
		end
		render layout: 'application'
	end

	def update_settings
		die
		redirect_to :back
	end


end