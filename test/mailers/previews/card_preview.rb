class CardPreview < ActionMailer::Preview

	#http://dev.amraplife.com:3000/rails/mailers/card/send_card
	def send_card
		card = Card.last || Card.new( to_email: 'test@example.com', from_name: 'Michael', to_name: 'Vivtoria', pub_id: 'test1' )

		CardMailer.send_card( card )
	end

end
