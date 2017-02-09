
class Equipment < ActiveRecord::Base 

	validates		:title, presence: true, unless: :allow_blank_title?

	attr_accessor	:slug_pref
	
	acts_as_nested_set
	
	has_many :movements
	has_many :workout_movements
	has_many :workouts, -> { distinct }, through: :workout_movements

	include FriendlyId
	friendly_id :slugger, use: [ :slugged, :history ]
	


	def slugger
		if self.slug_pref.present?
			self.slug = nil # friendly_id 5.0 only updates slug if slug field is nil
			return self.slug_pref
		else
			return self.title
		end
	end
	

	def to_s
		self.title
	end

	private 
		def allow_blank_title?
			self.slug_pref.present?
		end
end