
class MovementAdminController < SwellMedia::AdminController 
	before_action :set_movement, only: [:show, :edit, :update, :destroy]

	def create
		@movement = Movement.new( movement_params )
		@movement.save 
		redirect_to edit_movement_admin_path( @movement )
	end

	def destroy
		@movement.destroy
		redirect_to movement_admin_index_path
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

		@movements = @movements.page( params[:page] )
		
	end

	def update
		@movement.update( movement_params )
		redirect_to :back
	end


	private
		def movement_params
			params.require( :movement ).permit( :title, :aliases_csv, :equipment_id, :description,  :content, :status, :measured_by, :anatomy, :tags_csv ) 	
		end

		def set_movement
			@movement = Movement.friendly.find( params[:id] )
		end
end