
class Observation < ActiveRecord::Base

	# attr_accessor :content, :stop, :start

	#enum measure_type: { 'score' => 0, 'time' => 2, 'length' => 4, 'mass' => 6, 'volume' => 8, 'energy' => 10, 'reps' => 12, 'percent' => 14, 'temperature' => 16, 'pressure' => 18 }

	before_create 	:set_defaults
	validate 		:gotta_have_value_or_notes

	belongs_to 	:observed, polymorphic: true, touch: true
	belongs_to 	:user
	belongs_to 	:unit
	belongs_to 	:parent, class_name: 'Observation'

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

	def self.journal_entry
		self.where( observed: nil ).where.not( notes: nil )
	end


	def display_value( opts={} )
		opts[:precision] ||= 2

		if self.unit.nil?
			"#{self.value}"
		else
			self.unit.convert_from_base( self.value, opts )
		end

		# if self.unit.nil?
		# 	"#{value}"
		# elsif self.unit.is_time?
		# 	return ChronicDuration.output( self.value, format: :chrono )
		# elsif self.unit.is_percent?
		# 	return "#{( self.value * 100.to_f ).round( opts[:precision] )}%"
		# else
		# 	stored_unit = self.unit.base_unit
		# 	if stored_unit.present?
		# 		value = ( self.value / self.unit.conversion_factor.to_f ).round( opts[:precision] )
		# 	else
		# 		value = self.value
		# 	end
		# 	"#{value} #{self.unit.abbrev}"
		# end
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

		if self.value.present? && self.observed.present?
			str += "recorded #{self.display_value} for #{self.observed.try( :title )} "
		elsif self.value.present? && self.observed.nil?
			str += "recorded #{self.display_value} "
		elsif self.started_at.present? && self.ended_at.nil?
			str += "started #{self.observed.try( :title )} "
		else
			str += "said "
		end

		str += self.notes if self.notes.present?

		str.strip
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

			self.unit ||= self.observed.try( :unit )

		end

end
