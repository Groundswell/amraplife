
json.title @workout.title

json.workout_type @workout.workout_type
json.human_type @workout.human_type
json.cover_img @workout.cover_image

json.overview_title @workout.overview_title
json.overview_content @workout.overview_content

json.segments @workout.workout_segments.each do |segment|
	json.id segment.id
	json.seq segment.seq
	json.segment_type segment.segment_type
	json.content segment.content
	json.duration segment.duration
	json.repeat_count segment.repeat_count
	json.repeat_interval segment.repeat_interval
end