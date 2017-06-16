class MetricAlexaSkillsController < ActionController::Base
	protect_from_forgery :except => [:create]


	def create
		# Check that it's a valid Alexa request
		request_json = JSON.parse(request.raw_post)
		# Creates a new Request object with the request parameter.
		request = AlexaRubykit.build_request(request_json)

		# We can capture Session details inside of request.
		# See session object for more information.
		session = request.session
		# puts session.new?
		# puts session.has_attributes?
		# puts session.session_id
		# puts session.user_defined?

		# We need a response object to respond to the Alexa.
		response = AlexaRubykit::Response.new

		# We can manipulate the request object.
		#
		#puts "#{request.to_s}"
		#puts "#{request.request_id}"

		# Response
		# If it's a launch request
		if (request.type == 'LAUNCH_REQUEST')
			# Process your Launch Request
			# Call your methods for your application here that process your Launch Request.
			response.add_speech('Ruby running ready!')
			response.add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )
		end

		if (request.type == 'INTENT_REQUEST')
			# Process your Intent Request
			puts "#{request.slots}"
			puts "#{request.name}"
			response.add_speech("I received an intent named #{request.name}?")
			response.add_hash_card( { :title => 'Ruby Intent', :subtitle => "Intent #{request.name}" } )
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
