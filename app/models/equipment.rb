
class Equipment < ActiveRecord::Base 
	
	acts_as_nested_set
	
	has_many :movements
	has_many :workout_movements
	has_many :workouts, -> { distinct }, through: :workout_movements
	

	def to_s
		self.title
	end
end