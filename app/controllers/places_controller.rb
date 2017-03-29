
class PlacesController < ApplicationController
	before_action :set_place, only: :show


	def index
		@places = Places.published.order( :title )
		@places = @places.page( params[:page] )
		set_page_meta( title: 'Places )°( AMRAP Life' )
	end

	def show
		set_page_meta( title: @place.title, description: (@place.description || @place.content).html_safe )
	end


  private
	# Use callbacks to share common setup or constraints between actions.
	def set_place
		@place = Place.published.friendly.find(params[:id])
	end

end
