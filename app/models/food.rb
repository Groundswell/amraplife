
class Food < ActiveRecord::Base

	validates		:title, presence: true, unless: :allow_blank_title?


	private
		def allow_blank_title?
			self.slug_pref.present?
		end
end