
json.summary do
	json.id 			@result.id
	json.tmp_id			@result.tmp_id
	json.workout_title  @result.observed.to_s
	json.workout_type 	@result.observed.workout_type
	json.value 			@result.value
	json.unit 			@result.unit
	json.sub_value 		@result.sub_value
	json.notes 			@result.notes
	json.rx 			@result.rx
	json.started_at 	@result.started_at.to_s( :short )
	json.ended_at 		@result.ended_at.to_s( :short )
	json.url 			workout_result_url(@result, format: :json)
end

json.segments @result_segments.each do |segment|
	json.id segment.id
	json.segment_type segment.observed.try( :segment_type )
	json.content segment.content
	json.value segment.value
	json.unit segment.unit
	json.recorded_at segment.recorded_at
end