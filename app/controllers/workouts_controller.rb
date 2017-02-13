class WorkoutsController < ApplicationController
	before_action :set_workout, only: :show


	def index
		@workouts = Workout.published.order( :title )
		@count = @workouts.count
		@workouts = @workouts.page( params[:page] )
		set_page_meta( title: 'Workouts )°( AMRAP Life' )
	end

	def show
		set_page_meta( title: @workout.title )
	end


  private
	# Use callbacks to share common setup or constraints between actions.
	def set_workout
		@workout = Workout.published.friendly.find(params[:id])
	end

end
