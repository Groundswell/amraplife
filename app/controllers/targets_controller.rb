
class TargetsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :get_target, except: [ :create, :index ]

	layout 'lifemeter'

	def create
		@target = current_user.targets.new( target_params )
		@target.save
		redirect_to :back
	end

	def destroy
		@target.destroy
		redirect_to targets_path
	end

	def edit
		
	end

	def index
		@targets = current_user.targets.order( created_at: :desc ).page( params[:page] )
	end

	def update
		@target.update( target_params )
		redirect_to :back
	end


	private
		def get_target
			@target = current_user.targets.find( params[:id] )
		end

		def target_params
			params.require( :target ).permit( :parent_obj_id, :parent_obj_type, :status, :target_type, :min, :max, :direction, :period, :unit_id, :start_at, :end_at, :value )
		end

end