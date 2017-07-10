
class UserInput < ActiveRecord::Base
	# stores a record of all user commands
	# also holds logic for parsing and creating all 
	# generated objects

	belongs_to 	:user 
	belongs_to 	:created_obj, polymorphic: true

	def parse_content!
		# take what the user said, try to make sense of it, and create
		# any objects if requested (e.g. observations, messages, etc.)

		# parse srings of the form 'activity_code=234:23.43'

		# for simplicity, just strip leading record or log
		str = self.content.gsub( /\A(record|log)/, '' ).strip

		if str.match( /\Ai*\s*ate/i )
			# ate something.... send it to the nutrition service
		end 

		# one or more word character(s) followed by zero or more whitespace, 
		# then an = or 'is' or 'for'
		# then possibly more whitespace, then one or more numbers with possibly an
		# ampersand, colons, and maybe training an 'rx'
		# for now, just look at beginning of string (the \A). Can remove it to allow many obs from one str
		matches = str.match(/(\A\w+\s* (=|is|was|for) \s*[0-9a-zA-Z&:\.%]+\s*[rx]*)/ix )
		if matches.present?
			# split on =, see if left-hand matches a metric, parse right-hand values and record
			separator = matches.captures[1]

			if separator == 'for'
				key = matches.captures[0].split( separator )[1].strip
				val = matches.captures[0].split( separator )[0].strip
			else
				key = matches.captures[0].split( separator )[0].strip
				val = matches.captures[0].split( separator )[1].strip
			end

			if match = val.match( /[a-zA-Z%]+(\s|\z)/ )
				unit = match.to_s.strip.singularize
				val.gsub!( match.to_s, '' )
			end
			# always store time as secs
			if val.match( /:/ )
				val = ChronicDuration.parse( val )
				unit ||= 'sec'
			elsif ['minute', 'minutes', 'min', 'mins'].include?( unit )
				unit = 'sec'
				val = val.to_i * 60
			elsif ['hour', 'hours', 'hr', 'hrs'].include?( unit )
				unit = 'sec'
				val = val.to_i * 3600
			end
				
			# get metric from the user's assigned metrics
			observed = self.user.metrics.find_by_alias( key.downcase )
			if observed.nil?
				# check the factory metrics
				default_metric = Metric.where( user_id: nil ).find_by_alias( key.downcase )
				if default_metric.present?
					# make a copy for the user
					observed = default_metric.dup
					observed.user = self.user
					observed.save
				else
					# if all else fails, create a custom metric
					observed ||= self.user.metrics.create( title: key.downcase, unit: unit )
				end
			end

			self.created_obj = Observation.create( user: self.user, observed: observed, value: val, notes: matches.post_match )
			self.save
			return self.created_obj

		# verb condition - e.g. "ran 3miles"
		# string begins with congruent word characters, then whitespace, 
		# then numbers (optionally connected to unit)
		elsif matches = str.match( /(\A\w+)\s+([0-9]+\w*)/ )
			
			key = matches.captures[0].strip
			val = matches.captures[1].strip

			if match = val.match( /[a-zA-Z%]+(\s|\z)/ )
				unit = match.to_s.strip.singularize
				val.gsub!( match.to_s, '' )
			end
			# always store time as secs
			if val.match( /:/ )
				val = ChronicDuration.parse( val )
				unit ||= 'sec'
			elsif ['minute', 'minutes', 'min', 'mins'].include?( unit )
				unit = 'sec'
				val = val.to_i * 60
			elsif ['hour', 'hours', 'hr', 'hrs'].include?( unit )
				unit = 'sec'
				val = val.to_i * 3600
			end

			# get metric from the user's assigned metrics
			observed = self.user.metrics.find_by_alias( key.downcase )
			if observed.nil?
				# check the factory metrics
				default_metric = Metric.where( user_id: nil ).find_by_alias( key.downcase )
				if default_metric.present?
					# make a copy for the user
					observed = default_metric.dup
					observed.user = self.user
					observed.save
				else
					observed ||= self.user.metrics.create( title: key.downcase, unit: unit )
				end
			end

			self.created_obj = Observation.create( user: self.user, observed: observed, value: val, notes: matches.post_match )
			self.save
			return self.created_obj

		elsif matches = str.match( /(\Astarted|\Astart)\s+(\w+)/ )
			# start something
			# get metric from the user's assigned metrics
			observed = self.user.metrics.find_by_alias( matches.captures.second )
			if observed.nil?
				# check the factory metrics
				default_metric = Metric.where( user_id: nil ).find_by_alias( matches.captures.second )
				if default_metric.present?
					# make a copy for the user
					observed = default_metric.dup
					observed.user = self.user
					observed.save
				else
					observed ||= self.user.metrics.create( title: matches.captures.second, unit: 'sec' )
				end
			end

			self.created_obj = Observation.create( user: self.user, observed: observed, started_at: Time.zone.now, notes: matches.post_match )
			self.save
			return self.created_obj

		elsif matches = str.match( /(\Astopped|\Astop)\s+(\w+)/ )
			# stop something
			observed = self.user.metrics.where( ":term = ANY( aliases )", term: matches.captures.second ).last
			obs = self.user.observations.where( observed_type: 'Metric', observed_id: observed.try( :id ) ).where( 'started_at is not null' ).order( started_at: :asc ).last
			return Observation.new( errors: "No Active Timer" ) if obs.nil?
			obs.stop!
			obs.notes += matches.post_match if matches.post_match.present?
			return obs
		end

		# nothing matches -- it's just a note
		self.created_obj = Observation.create( user: self.user, notes: str, raw_input: raw_input )
		self.save
		return self.created_obj

	end
end