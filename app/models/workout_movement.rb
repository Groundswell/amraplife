class WorkoutMovement < ActiveRecord::Base

	belongs_to :movement
	belongs_to :workout
	belongs_to :equipment
	belongs_to :workout_segment

	before_save :set_equipment

	before_save :deal_with_uniqueness

	def to_s
		self.movement.to_s
	end

	private
		def deal_with_uniqueness
			# if there's already a movement for this
			if existing = self.workout.workout_movements.find_by( movement_id: self.movement_id )
				# update the existing record with thsi one's data
				existing.update_column( :equipment_id, self.equipment_id ) unless self.equipment_id.nil?
				existing.update_column( :m_rx, self.m_rx ) unless self.m_rx.nil?
				existing.update_column( :f_rx, self.f_rx ) unless self.f_rx.nil?
				return false #throw this record away
			end
		end

		def set_equipment
			self.equipment ||= self.movement.equipment
		end

end
