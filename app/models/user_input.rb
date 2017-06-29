
class UserInput < ActiveRecord::Base

	belongs_to 	:user 
	belongs_to 	:created_obj, polymorphic: true

	def parse_content!
		
	end
end