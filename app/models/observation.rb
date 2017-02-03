
class Observation < ActiveRecord::Base

	#acts_as_nested_set

	belongs_to 	:observed, polymorphic: true


	def human_value

		if self.observed.try( :workout_type ) == 'amrap'
			return "#{self.value.to_i} rds & #{self.sub_value.to_i} reps"

		elsif self.observed.try( :workout_type ) == 'strength'
			return "#{self.value.to_i}"
			
		elsif self.unit == 'secs'
			ChronicDuration.output( self.value, format: :chrono )
		else
			self.value
		end
	end

	def to_s
		return "#{self.human_value} #{self.unit}"
	end


end