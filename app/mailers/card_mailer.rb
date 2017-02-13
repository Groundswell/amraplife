class CardMailer < ActionMailer::Base
	default :from => 'no-reply@amraplife.com'


	def send_card( card )
    	@card = card
    	mail( :to => @card.to_email, :subject => "Happy Valentines Day from #{@card.from_name}" )
	end
end
