
class WorkoutResultsController < ApplicationController
	protect_from_forgery except: [ :create ]

	layout 'dash'


	def create
		data = JSON.parse( params[:result] )

		workout = Workout.friendly.find( data['workout_id'] )
		@result = Observation.create( 
			observed_type:  'Workout',
			observed_id:  	workout.id,
			tmp_id: 		data['tmp_id'],
			rx: 			data['rx'],
			notes: 			data['notes'],
			value: 		 	data['value'],
			sub_value: 		data['sub_value'],
			unit: 		 	data['unit'],
			started_at: 	data['started_at'],
			ended_at: 		data['ended_at'],
			recorded_at: 	Time.zone.now
			)


		@segment_data = data['segment_results']
		@segment_data.each do |result|
			next if result['segment_type'] == 'workout'
			segment = WorkoutSegment.find( result['segment_id'] )
		
			observation = Observation.create(
					parent_id: 		@result.id,
					observed: 		segment,
					value: 			result['value'],
					unit: 			result['unit'],
					content: 		result['content'],
					recorded_at: 	result['recorded_at']
				)
			#observation.move_to_child_of( @result )
		end

	end

	def index
		@results = Observation.where( observed_type: 'Workout' ).order( recorded_at: :desc )
	end

	def show
		@result = Observation.find_by( id: params[:id] )
		@result ||= Observation.find_by( tmp_id: params[:id] )
		@result_segments = Observation.where( parent_id: @result.id )
	end

end