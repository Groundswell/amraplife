class ObservationAlexaSkillsController < ActionController::Base
	protect_from_forgery :except => [:create]


	def create
		# @todo Check that it's a valid Alexa request
		alexa_request = AlexaRubykit.build_request( JSON.parse(request.raw_post) )
		alexa_session = request.session
		alexa_response = AlexaRubykit::Response.new

		# Response
		if (alexa_request.type == 'LAUNCH_REQUEST')
			# Process your Launch Request
			alexa_response.add_speech('Welcome ')
			# alexa_response.add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )
		end

		if (alexa_request.type == 'INTENT_REQUEST')
			# Process your Intent Request
			puts "#{alexa_request.slots}"
			puts "#{alexa_request.name}"

			if alexa_request.name == 'LogMetricObservationIntent'
				alexa_response.add_speech("Logging Metric")
				# alexa_response.add_hash_card( { :title => 'Logging Metric', :subtitle => "Intent #{alexa_request.name}" } )
			elsif alexa_request.name == 'LogStartObservationIntent'
				alexa_response.add_speech("Starting timer")
				# alexa_response.add_hash_card( { :title => 'Logging Metric', :subtitle => "Intent #{alexa_request.name}" } )
			elsif alexa_request.name == 'LogStopObservationIntent'
				alexa_response.add_speech("Stopping timer")
				# alexa_response.add_hash_card( { :title => 'Logging Metric', :subtitle => "Intent #{alexa_request.name}" } )
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
