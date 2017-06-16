class ObservationAlexaSkillsController < ActionController::Base
	protect_from_forgery :except => [:create]


	def create
		# @todo Check that it's a valid Alexa request

		request = AlexaRubykit.build_request( JSON.parse(request.raw_post) )
		session = request.session
		response = AlexaRubykit::Response.new

		# Response
		if (request.type == 'LAUNCH_REQUEST')
			# Process your Launch Request
			response.add_speech('Welcome ')
			# response.add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )
		end

		if (request.type == 'INTENT_REQUEST')
			# Process your Intent Request
			# puts "#{request.slots}"
			# puts "#{request.name}"

			if request.name == 'LogMetricIntent'
				response.add_speech("Logging Metric")
				response.add_hash_card( { :title => 'Ruby Intent', :subtitle => "Intent #{request.name}" } )
			else
				response.add_speech("Recieved Intent #{request.name}")
			end
		end

		if (request.type =='SESSION_ENDED_REQUEST')
			# Wrap up whatever we need to do.
			puts "#{request.type}"
			puts "#{request.reason}"
			halt 200
		end

		# Return response
		render json: response.build_response
	end
end
