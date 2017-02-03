
class MovementsController < ApplicationController
	before_action :set_movement, only: [:show, :edit, :update, :destroy]

	layout 'dash'
	
	def create
		@movement = Movement.new( movement_params )
		@movement.save 
		redirect_to edit_movement_path( @movement )
	end

	def destroy
		@movement.destroy
		redirect_to movements_url
	end

	def index
		by = params[:by] || 'title'
		dir = params[:dir] || 'asc'
		@movements = Movement.order( "#{by} #{dir}" )
		if params[:q]
			match = params[:q].downcase.singularize.gsub( /\s+/, '' )
			@movements = @movements.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match )
			@movements << Movement.find_by_alias( match )
		end
		set_page_meta( title: 'Movements )°( AMRAP Life' )
	end


	def show
	end

	def update
		@movement.update( movement_params )
		redirect_to :back
	end



	private
		# Use callbacks to share common setup or constraints between actions.
		def set_movement
			@movement = Movement.friendly.find( params[:id] )
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def movement_params
			params.require( :movement ).permit( :parent_id, :equipment_id, :title, :aliases, :aliases_csv, :description, :measured_by )
		end
end

