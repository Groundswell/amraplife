
class Observation < ActiveRecord::Base

	attr_accessor :content, :stop, :start

	before_create 	:set_defaults
	validate 		:gotta_have_value_or_notes

	belongs_to 	:observed, polymorphic: true
	belongs_to 	:user

	TIME_UNITS = [ 'day', 'days', 'hr', 'hrs', 'hour', 'hours', 'minute', 'minutes', 'min', 'mins', 'sec', 'secs', 'seconds' ]

	def self.dated_between( start_date=1.month.ago, end_date=Time.zone.now )
		start_date = start_date.to_datetime.beginning_of_day
		end_date = end_date.to_datetime.end_of_day
		
		where( recorded_at: start_date..end_date )
	end

	def self.for( observed )
		where( observed_id: observed.id, observed_type: observed.class.name )
	end
	class << self
		alias_method :of, :for
	end

	def self.for_day( day=Time.zone.now )
		self.dated_between( day.beginning_of_day, day.end_of_day )
	end


	def self.new_from_string( str, opts={} )
		# parse srings of the form 'activity_code=234:23.43'

		# one or more word character(s) followed by zero or more whitespace, 
		# then an = or 'is' or 'for'
		# then possibly more whitespace, then one or more numbers with possibly an
		# ampersand, colons, and maybe training an 'rx'
		# for now, just look at beginning of string (the \A). Can remove it to allow many obs from one str
		matches = str.match(/(\A\w+\s* (=|is|for) \s*[0-9a-zA-Z&:\.%]+\s*[rx]*)/ix )
		if matches.present?
			# split on =, see if left-hand matches a metric, parse right-hand values and record
			separator = matches.captures[1]
			key = matches.captures[0].split( separator )[0].strip
			val = matches.captures[0].split( separator )[1].strip

			if match = val.match( /[a-zA-Z%]+(\s|\z)/ )
				unit = match.to_s.strip
				val.gsub!( match.to_s, '' )
			end
			# always store time as secs
			if val.match( /:/ )
				val = ChronicDuration.parse( val )
				unit ||= 'secs'
			elsif ['minute', 'minutes', 'min', 'mins'].include?( unit )
				val = val.to_i * 60
			elsif ['hour', 'hours', 'hr', 'hrs'].include?( unit )
				val = val.to_i * 3600
			end
				

			observed = opts[:user].metrics.find_by_alias( key.downcase )
			observed ||= opts[:user].metrics.create( title: key.downcase, unit: unit )

			return Observation.new( user: opts[:user], observed: observed, value: val, notes: matches.post_match )

		elsif matches = str.match( /(\Astarted|\Astart)\s+(\w+)/ )
			# start something
			observed = opts[:user].metrics.where( ":term = ANY( aliases )", term: matches.captures.second ).last
			observed ||= Metric.create( title: matches.captures.second, user: opts[:user] )
			return Observation.new( user: opts[:user], observed: observed, started_at: Time.zone.now, notes: matches.post_match )
		elsif matches = str.match( /(\Astopped|\Astop)\s+(\w+)/ )
			# stop something
			observed = opts[:user].metrics.where( ":term = ANY( aliases )", term: matches.captures.second ).last
			obs = opts[:user].observations.where( observed_type: 'Metric', observed_id: observed.try( :id ) ).where( 'started_at is not null' ).order( started_at: :asc ).last
			return Observation.new( errors: "No Active Timer" ) if obs.nil?
			obs.stop
			obs.notes += matches.post_match if matches.post_match.present?
			return obs
		end

		# nothing matches -- it's just a note
		return Observation.new( user: opts[:user], notes: str )


	end



	def human_value
		if self.observed.try( :workout_type ) == 'amrap'
			return "#{self.value.to_i} rds & #{self.sub_value.to_i} reps"

		elsif self.observed.try( :workout_type ) == 'strength'
			return "#{self.value.to_i}"
			
		elsif self.value.present? && TIME_UNITS.include?( self.unit )
			ChronicDuration.output( self.value, format: :chrono )
		else
			"#{self.value}#{self.unit}"
		end
	end

	def input_value
		if self.value.present? && TIME_UNITS.include?( self.unit )
			ChronicDuration.output( self.value, format: :chrono )
		else
			self.value
		end
	end

	def stop
		self.ended_at = Time.zone.now
		self.recorded_at = Time.zone.now
		self.value = self.ended_at.to_i - self.started_at.to_i
	end

	def to_s
		return "#{self.human_value} #{self.unit}"
	end


	private


		def gotta_have_value_or_notes
			if self.value.blank? && self.notes.blank? && self.started_at.blank?
				self.errors.add( :value, "Empty Observation" )
				return false
			end
		end

		def set_defaults
			self.recorded_at ||= Time.zone.now
			self.started_at ||= Time.zone.now

			if self.observed.try( :unit ).present?
				self.unit = self.observed.unit
			end
			#self.value = self.duration if self.activity.present? && self.activity.is_time? && self.started_at && self.ended_at
		end

end