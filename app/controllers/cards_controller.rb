
class CardsController < ApplicationController 
	before_action :set_card, only: :show


	def create
	end

	def show
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