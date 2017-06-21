
class ObservationAlexaSkillsController < ActionController::Base
	protect_from_forgery :except => [:create]

	def cancel_intent

		add_speech("todo. Say stuff about canceling the skill.")

	end

	def help_intent

		add_speech("todo. Say stuff about how to use the skill.")

	end

	def launch_request
		# Process your Launch Request
		add_speech("Welcome #{user.try(:full_name)}, to AMRAP Life.  How can I help you?")
		# add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )

	end

	def log_metric_observation_intent

		observed_metric = get_user_metric( user, alexa_params[:action], alexa_params[:unit] )

		if observed_metric.nil?
			add_speech("I'm sorry, I don't know how to log information about #{alexa_params[:action]}.")
			return
		end

		Observation.create( user: user, observed: observed_metric, value: alexa_params[:value], unit: alexa_params[:unit], notes: "start #{alexa_params[:action]}" )

		if alexa_params[:action].present?

			add_speech("Logging that you #{alexa_params[:action]} #{alexa_params[:value]} #{alexa_params[:unit]}")

		else

			add_speech("Logging #{alexa_params[:value]} #{alexa_params[:unit]}")

		end

	end

	def log_start_observation_intent

		observed_metric = get_user_metric( user, alexa_params[:action], 'seconds' )

		if observed_metric.nil?
			add_speech("I'm sorry, I don't know how to log information about #{alexa_params[:action]}.")
			return
		end

		Observation.create( user: user, observed: observed_metric, started_at: Time.zone.now, notes: "start #{alexa_params[:action]}" )
		add_speech("Starting your #{alexa_params[:action]} timer")

	end

	def log_stop_observation_intent

		observed_metric = get_user_metric( user, alexa_params[:action], 'seconds' )

		if observed_metric.nil?
			add_speech("I'm sorry, I don't know how to log information about #{alexa_params[:action]}.")
			return
		end

		observations = user.observations.where( 'started_at is not null' ).order( started_at: :desc )
		observations = observations.where( observed: observed_metric ) if observed_metric.present?
		observation  = observations.first
		# observation = user.observations.where( observed_type: 'Metric', observed: observed_metric ).where( 'started_at is not null' ).order( started_at: :asc ).last

		if observation.present?
			observation.stop
			add_speech("Stopping your #{alexa_params[:action]} timer at #{observation.value.to_i} #{observation.unit}")
		else
			add_speech("I can't find any running #{alexa_params[:action]} timers.")
		end

	end

	def stop_intent

		add_speech("todo. Say stuff about stopping the skill.")

	end

	# Alexa Request Routing Action *********************************************
	# **************************************************************************
	def create
		# @todo Check that it's a valid Alexa request
		@alexa_request = AlexaRubykit.build_request( JSON.parse(request.raw_post) )
		@alexa_session = @alexa_request.session
		@alexa_response = AlexaRubykit::Response.new
		@alexa_params = Hash[*@alexa_request.slots.values.collect{|values| [values['name'].to_sym,values['value']]}.flatten]

		@user = User.friendly.find('mike')
		# @todo implement user finding and creation by alexa/amazon user id
		# user = User.find_or_create_by_amazon_user_id( @alexa_session.user_id )

		# Response
		if alexa_request.type == 'LAUNCH_REQUEST'

			launch_request()

		elsif alexa_request.type == 'INTENT_REQUEST'
			# Process your Intent Request
			puts "#{alexa_request.slots}"
			puts "#{alexa_request.name}"

			if alexa_request.name == 'AMAZON.StopIntent'

				stop_intent()

			elsif alexa_request.name == 'AMAZON.Cancel'

				cancel_intent()

			elsif alexa_request.name == 'AMAZON.HelpIntent'

				help_intent()

			elsif alexa_request.name == 'LogMetricObservationIntent'

				log_metric_observation_intent()

			elsif alexa_request.name == 'LogStartObservationIntent'

				log_start_observation_intent()

			elsif alexa_request.name == 'LogStopObservationIntent'

				log_stop_observation_intent()

			else

				add_speech("Recieved Intent #{@alexa_request.name}")

			end
		end

		if (@alexa_request.type =='SESSION_ENDED_REQUEST')
			# Wrap up whatever we need to do.
			puts "#{@alexa_request.type}"
			puts "#{@alexa_request.reason}"
			# halt 200
		end

		render json: @alexa_response.build_response
	end

	private

	def get_user_metric( user, action, unit )

		if action.present?

			observed_metric = Metric.where( user_id: user ).find_by_alias( alexa_params[:action].downcase )
			observed_metric ||= Metric.where( user_id: nil ).find_by_alias( alexa_params[:action].downcase ).try(:dup)
			# observed_metric ||= Metric.new( title: alexa_params[:action], unit: unit )
			observed_metric.update( user: user ) if observed_metric.present?

		end

		observed_metric
	end

	def user
		@user
	end

	def add_hash_card( args = {} )
		alexa_response.add_hash_card( args )
	end

	def add_speech(text)
		alexa_response.add_speech(text)
	end

	def alexa_params
		@alexa_params
	end

	def alexa_request
		@alexa_request
	end

	def alexa_response
		@alexa_response
	end

	def alexa_session
		@alexa_session
	end
end
