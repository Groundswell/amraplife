
class CardsController < ApplicationController 
	before_action :set_card, only: [ :show, :success ]


	def create
		@card = Card.new( card_params )
		@card.card_design = CardDesign.first
		if @card.save

			CardMailer.send_card( @card ).deliver

			redirect_to success_card_path( @card.pub_id )
		else
			set_flash "Card could not be sent", :error, @card
			redirect_to :back
			return false
		end
	end

	def new
		set_page_meta( title: 'Send a Card' )
	end

	def success
		set_page_meta( title: 'Thank You!' )
	end

	def show
		@card.update( viewed: true )
		set_page_meta( title: 'Your Card' )
	end


 	 private
	
		def card_params
			params.require( :card ).permit( :from_name, :from_email, :to_name, :to_email, :message )
		end
		# Use callbacks to share common setup or constraints between actions.
		def set_card
			@card = Card.find_by( pub_id: params[:id] )
		end
end