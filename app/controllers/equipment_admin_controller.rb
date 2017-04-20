
class EquipmentAdminController < SwellMedia::AdminController
	before_action :set_equipment, only: [:show, :edit, :update, :destroy]

	
	def create
		@equipment = Equipment.new( equipment_params )
		@equipment.save
		redirect_to edit_equipment_admin_path( @equipment )
	end

	def destroy
		@equipment.destroy
		redirect_to equipment_admin_index_url
	end


	def index
		by = params[:by] || 'title'
		dir = params[:dir] || 'asc'
		@equipment = Equipment.order( "#{by} #{dir}" )
		if params[:q]
			match = params[:q].downcase.singularize.gsub( /\s+/, '' )
			@equipment = @equipment.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match )
			@equipment << Equipment.find_by_alias( match )
		end

		@equipment = @equipment.page( params[:page] )
		
	end


	def update
		@equipment.update( equipment_params )
		redirect_to :back
	end


  private
	# Use callbacks to share common setup or constraints between actions.
	def set_equipment
		@equipment = Equipment.friendly.find( params[:id] )
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def equipment_params
		params.require( :equipment ).permit( :title, :description, :content, :status, :tags_csv )
	end
end
