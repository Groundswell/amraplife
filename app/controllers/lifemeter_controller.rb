class LifemeterController < ApplicationController

	before_filter :authenticate_user!, only: [:dash, :update_settings, :log]

	def dash
		@inputs = current_user.user_inputs.order( created_at: :desc ).page( params[:page] )
		# @start_date = 30.days.ago.beginning_of_day
		# @end_date = Time.zone.now.end_of_day

		# if params[:start_date].present? && params[:end_date].present?
		# 	@start_date = Date.strptime( params[:start_date], '%m/%d/%Y' ).beginning_of_day
		# 	@end_date = Date.strptime( params[:end_date], '%m/%d/%Y' ).end_of_day
		# end


		# top_observations 	= current_user.observations.where( observed_type: 'Metric' )
		# top_observations 	= top_observations.group( :observed_id ).having('COUNT(id) > 1').order( 'COUNT(id) DESC' )
		# top_observations	= top_observations.dated_between( @start_date, @end_date )
		# top_metric_ids 		= top_observations.limit(8).pluck( :observed_id )

		# @top_metrics = Metric.none
		# @top_metrics = Metric.where( id: top_metric_ids ).to_a if top_metric_ids.present?

		# @top_metric_observations = {}


		# if @top_metrics.present?

		# 	@top_metrics.each do |metric|

		# 		observations = current_user.observations.for( metric ).dated_between( @start_date, @end_date ).to_a

		# 		@top_metric_observations[metric.id] = observations if observations.present?

		# 	end

		# 	@top_metrics = @top_metrics.select{ |metric| @top_metric_observations[metric.id].present? } || []

		# end

		render layout: 'lifemeter'
	end

	def index
		if current_user
			redirect_to dash_lifemeter_index_path
			return false
		end

		set_page_meta(
			title: 'Life Meter by )°( AMRAP Life',
			slack_app: "A60G5B79P"
		)

		render layout: 'lifemeter_splash'
	end

	def log
		@day = ( params[:day].present? && params[:day].to_datetime ) || Time.zone.now

		@inputs = current_user.user_inputs.order( created_at: :desc ).page( params[:page] )

		@metrics = current_user.metrics

		@timers = current_user.observations.where.not( started_at: nil ).where( value: nil )

		render layout: 'lifemeter'
	end

	def update_settings

		current_user.nickname = params[:nickname] if params[:nickname].present?
		current_user.gender = params[:gender] if params[:gender].present?
		current_user.dob = params[:dob] if params[:dob].present?
		current_user.email = params[:email] unless params[:email].blank?

		current_user.full_name = params[:full_name] if params[:full_name].present?
		current_user.street = params[:street] unless params[:street].blank?
		current_user.street2 = params[:street2] unless params[:street2].blank?
		current_user.city = params[:city] unless params[:city].blank?
		current_user.state = params[:state] unless params[:state].blank?
		current_user.zip = params[:zip] unless params[:zip].blank?
		current_user.phone = params[:phone] unless params[:phone].blank?

		current_user.use_imperial_units = params[:use_imperial_units]
		if params[:new_password].present?
			if current_user.encrypted_password.nil?
				if params[:new_password] == params[:new_password_confirmation]
					current_user.password = params[:new_password]
				else
					set_flash 'Password Confirmation Does not Match', :warning
				end
			else
				if current_user.valid_password?( params[:current_password] )
					if params[:new_password] == params[:new_password_confirmation]
						current_user.password = params[:new_password]
					else
						set_flash 'Password Confirmation Does not Match', :warning
					end
				else
					set_flash 'Password not saved: Authentication failed', :warning
				end
			end
		end

		current_user.save

		sign_in( current_user, bypass: true )

		redirect_to :back
	end


end
