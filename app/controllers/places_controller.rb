
class PlacesController < ApplicationController
	before_action :set_place, only: :show


	def index
		@places = Place.published.order( :title )
		@places = @places.page( params[:page] )
		set_page_meta( title: 'Places )°( AMRAP Life' )
	end

	def show
		@featured_video = @place.featured_video

		set_page_meta( title: "#{@place.title} - #{@place.city}, #{@place.state}", description: (@place.description || @place.content).html_safe )
	end


  private
	# Use callbacks to share common setup or constraints between actions.
	def set_place
		@media = @place = Place.published.friendly.find(params[:id])
	end

end
