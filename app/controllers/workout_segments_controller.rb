
class WorkoutSegmentsController < ApplicationController 
	before_action :set_segment, only: [:edit, :update, :destroy]

	def create
		@segment = WorkoutSegment.new( segment_params )
		@segment.save

		redirect_to :back
	end

	def destroy
		@segment.destroy
		redirect_to :back
	end

	def update
		@segment.update( segment_params )
		redirect_to :back
	end

	private
		def set_segment
			@segment = WorkoutSegment.find( params[:id] )
		end

		def segment_params
			if params[:workout_segment][:duration]
				params[:workout_segment][:duration] = ( params[:workout_segment][:duration].split(':')[0].to_i * 60 ) + params[:workout_segment][:duration].split(':')[1].to_i
			end
			params.require( :workout_segment ).permit( :workout_id, :seq, :content, :decription, :segment_type, :timer_dir, :duration, :to_measure, :repeat_count, :every_interval )
		end
end