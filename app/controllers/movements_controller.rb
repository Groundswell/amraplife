
class MovementsController < ApplicationController
	before_action :set_movement, only: :show

	def index
		by = params[:by] || 'title'
		dir = params[:dir] || 'asc'
		@movements = Movement.published.order( "#{by} #{dir}" )
		if params[:q]
			match = params[:q].downcase.singularize.gsub( /\s+/, '' )
			@movements = @movements.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match )
			@movements << Movement.find_by_alias( match )
		end

		@movements = @movements.page( params[:page] )

		set_page_meta( title: 'Movements )°( AMRAP Life' )
	end

	def show
		@media = @movement
		set_page_meta( @movement.page_meta )
	end


	private
		# Use callbacks to share common setup or constraints between actions.
		def set_movement
			@movement = Movement.published.friendly.find( params[:id] )
		end

end

