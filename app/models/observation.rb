
class Observation < ActiveRecord::Base

	# attr_accessor :content, :stop, :start

	before_create 	:set_defaults
	validate 		:gotta_have_value_or_notes

	belongs_to 	:observed, polymorphic: true
	belongs_to 	:user

	TIME_UNITS = [ 'day', 'hr', 'hour', 'minute', 'min', 'sec', 'second' ]

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



	def human_value
		if self.observed.try( :workout_type ) == 'amrap'
			return "#{self.value.to_i} rds & #{self.sub_value.to_i} reps"

		elsif self.observed.try( :workout_type ) == 'strength'
			return "#{self.value.to_i}"

		elsif self.value.present? && TIME_UNITS.include?( self.unit )
			ChronicDuration.output( self.value, format: :chrono )
		else
			"#{self.value} #{self.unit}"
		end
	end

	def input_value
		if self.value.present? && TIME_UNITS.include?( self.unit )
			ChronicDuration.output( self.value, format: :chrono )
		else
			self.value
		end
	end

	def stop!
		self.ended_at = Time.zone.now
		self.recorded_at = Time.zone.now
		self.value = self.ended_at.to_i - self.started_at.to_i
		self.save
	end

	def to_s( user=nil )
		str = ""
		if user = self.user
			str = 'You '
		else
			str = "#{self.user} "
		end

		if self.value.present?
			str += "recorded #{self.human_value} for #{self.observed.try( :title )} "
		elsif self.started_at.present? && self.ended_at.nil?
			str += "started #{self.observed.try( :title )} "
		else
			str += "said "
		end

		str += self.notes if self.notes.present?

		str
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
			#self.started_at ||= Time.zone.now

			if self.observed.try( :unit ).present?
				self.unit ||= self.observed.unit
			end
			#self.value = self.duration if self.activity.present? && self.activity.is_time? && self.started_at && self.ended_at
		end

end
