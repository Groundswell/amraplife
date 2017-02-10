
class PlaceAdminController < SwellMedia::AdminController
	before_action :set_place, only: [:show, :edit, :update, :destroy]

	def create
		@place = Place.new( place_params )
		@place.save 
		redirect_to edit_place_admin_path( @place )
	end

	def destroy
		@place.destroy
		redirect_to places_url
	end

	def index
		by = params[:by] || 'title'
		dir = params[:dir] || 'asc'
		@places = Place.order( "#{by} #{dir}" )
		if params[:q]
			match = params[:q].downcase.singularize.gsub( /\s+/, '' )
			@places = @places.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match )
			@places << Place.find_by_alias( match )
		end
		@place_count = @places.count
		@places = @places.page( params[:page] )
		
	end

	def update
		@place.update( place_params )
		redirect_to :back
	end


	private
		def place_params
			params.require( :place ).permit( :title, :description, :content, :status, :lat, :long, :address1, :address2, :city, :state, :zip, :phone, :hours, :cost ) 	
		end

		def set_place
			@place = Place.friendly.find( params[:id] )
		end
end