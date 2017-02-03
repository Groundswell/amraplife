
class WorkoutMovementsController < ApplicationController 
	before_action :set_movement, only: [:show, :edit, :update, :destroy]

	def create
		@movement = WorkoutMovement.new( movement_params )
		@movement.save
		if @movement.workout.workout_type == 'tabata'
			@movement.workout.workout_segments.create duration: 20, title: @movement 
			@movement.workout.workout_segments.create segment_type: 'rest', duration: 10
		end
		redirect_to :back
	end

	def destroy
		@movement.destroy
		redirect_to :back
	end

	private
		def set_movement
			@movement = WorkoutMovement.find( params[:id] )
		end

		def movement_params
			params.require( :workout_movement ).permit( :workout_id, :movement_id, :equipment_id, :decription, :m_rx, :f_rx )
		end
end