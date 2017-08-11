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

		set_page_meta(
			title: 'Life Meter by )°( AMRAP Life',
			slack_app: "A60G5B79P"
		)

		render layout: 'lifemeter_splash'
	end

	def update_settings

		current_user.full_name = params[:full_name] if params[:full_name].present?
		current_user.gender = params[:gender] if params[:gender].present?
		current_user.dob = params[:dob] if params[:dob].present?
		current_user.email = params[:email] unless params[:email].blank?
		current_user.use_metric = params[:use_metric]
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
