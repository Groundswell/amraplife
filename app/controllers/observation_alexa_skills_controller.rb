
class ObservationAlexaSkillsController < ActionController::Base
	protect_from_forgery :except => [:create]


	def create
		# @todo Check that it's a valid Alexa request
		alexa_request = AlexaRubykit.build_request( JSON.parse(request.raw_post) )
		alexa_session = request.session
		alexa_response = AlexaRubykit::Response.new

		user = User.friendly.find('mike')
		# @todo implement user finding and creation by alexa/amazon user id
		# user = User.find_or_create_by_amazon_user_id( alexa_session.user_id )

		# Response
		if alexa_request.type == 'LAUNCH_REQUEST'
			# Process your Launch Request
			alexa_response.add_speech("Welcome #{user.try(:full_name)}, to AMRAP Life.  How can I help you?")
			# alexa_response.add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )

		elsif alexa_request.type == 'INTENT_REQUEST' && alexa_request.name == 'AMAZON.HelpIntent'

			alexa_response.add_speech("todo. Say stuff about how to use the skill.")

		elsif alexa_request.type == 'INTENT_REQUEST'
			# Process your Intent Request
			puts "#{alexa_request.slots}"
			puts "#{alexa_request.name}"

			action = (alexa_request.slots['action'] || {})['value']

			value = (alexa_request.slots['value'] || {})['value']
			unit = (alexa_request.slots['metric'] || {})['value']
			unit ||= 'seconds' if alexa_request.name == 'LogStartObservationIntent'

			unit ||= 'seconds' if alexa_request.name == 'LogStartObservationIntent'

			if action.present?

				observed_metric = Metric.where( user_id: user ).find_by_alias( action.downcase )
				observed_metric ||= Metric.where( user_id: nil ).find_by_alias( action.downcase ).try(:dup)
				# observed_metric ||= Metric.new( title: action, unit: unit )
				observed_metric.update( user: user ) if observed_metric.present?

			end

			if action.present? && observed_metric.nil?

				alexa_response.add_speech("I'm sorry, I don't know how to log information about #{action}.")

			elsif alexa_request.name == 'LogMetricObservationIntent'

				Observation.create( user: user, observed: observed_metric, value: value, unit: unit, notes: "start #{action}" )

				if action.present?

					alexa_response.add_speech("Logging that you #{action} #{value} #{unit}")

				else

					alexa_response.add_speech("Logging #{value} #{unit}")

				end

			elsif alexa_request.name == 'LogStartObservationIntent'

				Observation.create( user: user, observed: observed_metric, started_at: Time.zone.now, notes: "start #{action}" )
				alexa_response.add_speech("Starting your #{action} timer")

			elsif alexa_request.name == 'LogStopObservationIntent'

				observations = user.observations.where( 'started_at is not null' ).order( started_at: :desc )
				observations = observations.where( observed: observed_metric ) if observed_metric.present?
				observation  = observations.last
				# observation = user.observations.where( observed_type: 'Metric', observed: observed_metric ).where( 'started_at is not null' ).order( started_at: :asc ).last

				if observation.present?
					observation.stop
					alexa_response.add_speech("Stopping your #{action} timer at #{observation.value.to_i} #{observation.unit}")
				else
					alexa_response.add_speech("I can't find any running #{action} timers.")
				end

			else
				alexa_response.add_speech("Recieved Intent #{alexa_request.name}")
			end
		end

		if (alexa_request.type =='SESSION_ENDED_REQUEST')
			# Wrap up whatever we need to do.
			puts "#{alexa_request.type}"
			puts "#{alexa_request.reason}"
			halt 200
		end

		render json: alexa_response.build_response
	end
end
