class WorkoutBotService < AbstractBotService

	 add_intents( {

		audio_event: {
			utterances: [],
			slots: {}
		},

		cancel: {
			utterances: [ 'cancel' ],
			slots: {}
		},
   		stop: {
   			utterances: [ 'stop', 'pause', 'end' ],
			slots: {}
   		},
   		resume: {
   			utterances: [ 'resume' ],
			slots: {}
   		},

		workout_start: {
			utterances: [
				# (that) (i) (am) start(ed|ing) (to) working
				'(to )?(i am )?(start|starting) the workout of the day',
				'(to )?(i am )?(start|starting) workout of the day',
				'(to )?(i am )?(start|starting) working out',
				'(to )?(i am )?(start|starting) the workout',
				'(to )?(i am )?(start|starting) the wod',
				'(to )?(i am )?(start|starting) wod',
				'(to )?(i am )?(start|starting) the {workoutname} workout',
				'(to )?(i am )?(start|starting) {workoutname} workout',
			],
			slots:{
				workoutname: 'WorkoutName',
			},
		},

		workout_complete: {
			utterances: [
				'(to )?(i am )?(stop|done|finished|finish|complete) the workout of the day',
				'(to )?(i am )?(stop|done|finished|finish|complete) workout of the day',
				'(to )?(i am )?(stop|done|finished|finish|complete) the wod',
				'(to )?(i am )?(stop|done|finished|finish|complete) workout',
				'(to )?(i am )?(stop|done|finished|finish|complete) the workout',
				'(to )?(i am )?(stop|done|finished|finish|complete) working out',
				'(to )?(i am )?(stop|done|finished|finish|complete) wod',
				'(to )?(i am )?(stop|done|finished|finish|complete) the {workoutname} workout',
			],
			slots:{
				workoutname: 'WorkoutName',
			},
		},

		workout_describe: {
			utterances: [
				'what is {workoutname}(\?)?',
				'(to\s+)?describe {workoutname}(\?)?',
				'(to\s+)?describe today\'s workout(\?)?',
				'what is todays workout(\?)?',
				'what is the wod(\?)?',
				'what is the workout of the day(\?)?',
			],
			slots:{
				workoutname: 'WorkoutName',
			},
		},

		workout_list: {
			utterances: [
				'(to )?list workouts',
				'(to )?list all workouts',
			],
			slots:{},
		},

	} )

	add_slots( {
	  WorkoutName: {
		  regex: [
			  '.+'
		  ],
		  values: [
			  { value: "Glen", synonyms: [] },
			  { value: "Helen", synonyms: [] },
		]
	  }
  	} )

	def audio_event

		if params[:event] == 'AudioPlayer.PlaybackNearlyFinished' && ( repeat = (get_session_context( 'workout.audio.repeat' ) || 0).to_i ) != 0

			add_session_context( 'workout.audio.repeat', repeat-1 ) if repeat > 0

			audio_url = get_session_context( "workout.audio[#{repeat}].url" )
			audio_url ||= get_session_context( 'workout.audio.url' )

			add_audio_url( audio_url, enqueue: params[:token] )

		end

	end

	def cancel
		new_context
		add_speech("Cancelling")

		add_clear_audio_queue()

		user.user_inputs.create( content: raw_input, action: 'cancel', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{raw_input || 'cancel'}'" ) if user.present?
	end

	def pause

		if get_session_context( 'workout.type' ).blank?

			add_speech("You do not have any activity to pause.")

		elsif get_session_context( 'workout.type' ) == 'ft'

			call_intent( :workout_complete )

		else
			add_speech("Pausing workout.")
			add_stop_audio()
			user.user_inputs.create( content: raw_input, action: 'pause', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{raw_input || 'pause'}'" ) if user.present?
		end
	end

	def resume

		if get_session_context( 'workout.type' ).blank?

			add_speech("You do not have any activity to resume.")

		else
			add_speech("Resuming workout.")
			add_audio_url('https://cdn1.amraplife.com/assets/c45ca8e9-2a8f-4522-bdcb-b7df58f960f8.mp3', token: 'workout-player', offset: audio_player[:offset] )
		end

		user.user_inputs.create( content: raw_input, action: 'resume', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{raw_input || 'resume'}'" ) if user.present?

	end

	def stop
		add_speech("Stopping.")
		add_clear_audio_queue()
	end

	def workout_complete

		unless user.present?
			call_intent( :login )
			return
		end


		workout = Workout.find( get_session_context( 'workout.id' ).to_i )

		observation = user.observations.of( workout ).where( value: nil ).where( 'started_at is not null' ).order( started_at: :desc ).first

		unless observation.present?

			add_speech("Sorry, you haven't started a workout yet.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found' )
			return

		end

		if workout.workout_type == 'ft'

			observation.stop!

			speech = "Good Job. Logging a time of #{observation.value.to_i} #{observation.unit} for the #{workout.title}."

		elsif workout.workout_type == 'amrap'

			observation.value = params[:score]
			observation.save

			speech = "Good Job. Logging a score of #{params[:score] || 'NO SCORE'} for the #{workout.title} workout."

		end

		add_speech(speech)
		add_clear_audio_queue()
		new_context()

		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'updated', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{speech}'." )

	end

	def workout_describe
		unless user.present?
			call_intent( :login )
			return
		end

		workout_title = params[:workoutname]
		workout = get_workout( workout_title )

		speech = workout.description_speech
		add_speech(speech)

		user.user_inputs.create( content: raw_input, action: 'created', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{speech}'." )

	end

	def workout_list
		unless user.present?
			call_intent( :login )
			return
		end

		# @todo
	end

	def workout_start
		new_context

		unless user.present?
			call_intent( :login )
			return
		end

		workout_title = params[:workoutname]

		observation = nil

		workout = get_workout( workout_title )

		speech = "Before we start the #{workout.title}, let's quickly go over it.  "
		if workout.workout_type == 'ft'
			speech = "#{speech}#{workout.start_speech}  When you are done let me know by saying \"Alexa Stop\" and I will record your time.  Ready ready.  3, 2, 1, Go!"
		elsif workout.workout_type == 'amrap'
			speech = "#{speech}#{workout.start_speech}  I will let you know when you're done.  Ready ready.  3, 2, 1, Go!"
		else
			speech = "#{speech}#{workout.start_speech}  Ready ready.  3, 2, 1, Go!"
		end

		# remember workout information
		add_session_context( 'workout.id', workout.id )
		add_session_context( 'workout.title', workout.title )
		add_session_context( 'workout.started_at', Time.now.to_i )
		add_session_context( 'workout.type', workout.workout_type )


		# set audio context for workout
		one_minute_audio 	= 'https://cdn1.amraplife.com/assets/c45ca8e9-2a8f-4522-bdcb-b7df58f960f8.mp3'
		all_done_audio 		= 'https://www.soundboard.com/handler/DownLoadTrack.ashx?cliptitle=Beeping+and+whistling&filename=mt/MTQ1MzI4MzAzMTQ1Mzgw_jwPFPnna9_2bs.mp3'

		if workout.workout_type == 'ft'

			add_session_context( 'workout.audio.url', one_minute_audio )
			add_session_context( 'workout.audio.repeat', -1 )
			unit = 'sec'

		elsif workout.workout_type == 'amrap'

			rounds_of_audio = (workout.total_duration / 1.minute.to_f).floor

			add_session_context( 'workout.audio.url', one_minute_audio )
			add_session_context( 'workout.audio[1].url', all_done_audio )
			add_session_context( 'workout.audio.repeat', rounds_of_audio )
			unit = 'reps'

		end

		# observe the start of the workout.
		observation = Observation.create( user: user, observed: workout, unit: unit, started_at: Time.zone.now, notes: nil )

		# explain workout
		add_speech(speech)

		# and lay down those funky beats.
		add_audio_url( get_session_context( 'workout.audio.url' ) )

		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{speech}'." )


	end

	private

		def get_workout( workout_title = nil )

			workouts = Workout.active.where.not( description_speech: nil, start_speech: nil, description_speech: '', start_speech: '' )

			workout_count = workouts.count

			wod_index = ( ENV['TEST_WORKOUT_INDEX'] || Date.today.yday() % workout_count )

			workouts.offset( wod_index ).first

		end

end
