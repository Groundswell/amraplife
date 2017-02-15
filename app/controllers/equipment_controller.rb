
class EquipmentController < ApplicationController
	before_action :set_equipment, only: [ :show ]

	def index
		@equipment = Equipment.published.order( title: :asc ).page( params[:page] )
		set_page_meta( title: 'Equipment )°( AMRAP Life' )
	end

	def show
		set_page_meta( @equipment.page_meta )
	end



  private
	# Use callbacks to share common setup or constraints between actions.
	def set_equipment
		@equipment = Equipment.friendly.find( params[:id] )
	end

end
