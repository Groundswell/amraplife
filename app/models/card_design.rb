
class CardDesign < ActiveRecord::Base

	has_many 	:cards 

	include FriendlyId
	friendly_id :title, use: [ :slugged ]
	
end