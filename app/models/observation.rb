
class Observation < ActiveRecord::Base

	# attr_accessor :content, :stop, :start

	#enum measure_type: { 'score' => 0, 'time' => 2, 'length' => 4, 'mass' => 6, 'volume' => 8, 'energy' => 10, 'reps' => 12, 'percent' => 14, 'temperature' => 16, 'pressure' => 18 }

	before_create 	:set_defaults
	validate 		:gotta_have_value_or_notes

	belongs_to 	:observed, polymorphic: true
	belongs_to 	:user

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



	def display_value
		UnitService.new( val: self.value, stored_unit: self.unit, display_unit: self.display_unit, use_metric: self.user.use_metric ).convert_to_display
	end

	def is_time?
		self.unit == 's'
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
			str += "recorded #{self.display_value} for #{self.observed.try( :title )} "
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

			self.unit ||= self.observed.unit
			self.display_unit ||= self.observed.display_unit

		end

end
