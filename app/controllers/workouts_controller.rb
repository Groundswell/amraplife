class WorkoutsController < ApplicationController
	before_action :set_workout, only: [:show, :edit, :update, :destroy]

	layout 'dash'
	
	def create
		@workout = Workout.new( workout_params )
		@workout.save
		redirect_to edit_workout_path( @workout )
	end

	def destroy
		@workout.destroy
		redirect_to workouts_url
	end

	def edit
		set_page_meta( title: "Edit #{@workout} | Living AMRAP" )
		if @workout.workout_type == 'amrap'
			@segment = @workout.workout_segments.first || WorkoutSegment.new( duration: 0 )
			@segment.duration = @segment.formatted_duration
			render 'edit_amrap'
		end
		if @workout.workout_type == 'rft'
			@segment = @workout.workout_segments.first || WorkoutSegment.new()
			render 'edit_rft'
		end
		if @workout.workout_type == 'ft'
			render 'edit_ft'
		end
		if @workout.workout_type == 'eotm'
			@segment = @workout.workout_segments.first || WorkoutSegment.new( every_interval: 1 )
			render 'edit_eotm'
		end
		
	end

	def new
		@workout = Workout.new
	end

	def index
		@workouts = Workout.order( :title )
		set_page_meta( title: 'Workouts | Living AMRAP' )
	end

	def show
	end


	def update
		@workout.update( workout_params )
		redirect_to :back
	end


  private
	# Use callbacks to share common setup or constraints between actions.
	def set_workout
		@workout = Workout.friendly.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def workout_params
		params.require( :workout ).permit( :workout_type, :title, :description )
	end
end
