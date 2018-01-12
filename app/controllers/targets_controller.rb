
class TargetsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :get_target, except: [ :create, :index ]

	layout 'lifemeter'

	def create
		@target = current_user.targets.new( target_params )

		unit = target_params[:value].strip.split( /\s+/ ).last.gsub( /\d+/, '' ).singularize
		val = target_params[:value].strip.split( /\s+/ ).first.gsub( /[a-zA-Z]+/, '' )

		if unit.present?
			stored_unit = Unit.find_by_alias( unit )
			@target.unit = stored_unit if stored_unit.present?
		end

		@target.unit ||= @target.parent_obj.unit

		@target.value = @target.unit.convert_to_base( val )


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
		@target.value = target_params[:value]
		@target.status = target_params[:status]
		@target.target_type = target_params[:target_type]
		@target.min = target_params[:min]
		@target.max = target_params[:max]
		@target.direction = target_params[:direction]
		@target.period = target_params[:period]
		@target.start_at = target_params[:start_at]
		@target.end_at = target_params[:end_at]

		unit = target_params[:value].strip.split( /\s+/ ).last.gsub( /\d+/, '' ).singularize
		val = target_params[:value].strip.split( /\s+/ ).first.gsub( /[a-zA-Z]+/, '' )

		if unit.present?
			stored_unit = Unit.find_by_alias( unit )
			@target.unit = stored_unit if stored_unit.present?
		end

		@target.unit ||= @target.parent_obj.unit

		@target.value = @target.unit.convert_to_base( val )

		@target.save
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