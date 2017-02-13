
class CardsController < ApplicationController 
	before_action :set_card, only: [ :show, :success ]


	def create
		@card = Card.new( card_params )
		if @card.save

			# send email

			redirect_to success_card_path( @card.pub_id )
		else
			set_flash "Card could not be sent", :error
			redirect_to :back
			return false
		end
	end

	def new
	end

	def success
	end

	def show
		@card.update( viewed: true )
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