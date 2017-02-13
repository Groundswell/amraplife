
class Card < ActiveRecord::Base

	validates :to_email

	belongs_to :card_design

	before_create :set_pub_id


	private
		def set_pub_id
			self.pub_id = loop do
				token = SecureRandom.urlsafe_base64( 6 )
				break token unless Card.exists?( pub_id: token )
			end
		end

end