class WorkoutsController < ApplicationController
	before_action :set_workout, only: :show


	def index
		@workouts = Workout.published.order( :title )
		@workouts = @workouts.page( params[:page] )
		set_page_meta( page_title: 'Workouts )°( AMRAP Life' )
	end

	def show
		set_page_meta( page_title: "#{@workout.title} )°( AMRAP Life", description: @workout.content.html_safe )
	end


  private
	# Use callbacks to share common setup or constraints between actions.
	def set_workout
		@workout = Workout.published.friendly.find(params[:id])
	end

end
