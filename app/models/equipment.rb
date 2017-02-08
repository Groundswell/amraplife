
class Equipment < ActiveRecord::Base 

	validates		:title, presence: true, unless: :allow_blank_title?
	
	acts_as_nested_set
	
	has_many :movements
	has_many :workout_movements
	has_many :workouts, -> { distinct }, through: :workout_movements
	

	def to_s
		self.title
	end

	private 
		def allow_blank_title?
			self.slug_pref.present?
		end
end