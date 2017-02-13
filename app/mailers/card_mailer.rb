class CardMailer < ActionMailer::Base
	default :from => 'no-reply@amraplife.com'


	def send_card( card )
    	@user = card
    	mail( :to => @user.email, :subject => 'Happy Valentines Day' )
	end
end
