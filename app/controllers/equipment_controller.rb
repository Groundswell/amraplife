
class EquipmentController < ApplicationController
	before_action :set_equipment, only: [ :show ]

	def index
		@equipment = Equipment.published
	end

	def show
	end



  private
	# Use callbacks to share common setup or constraints between actions.
	def set_equipment
		@equipment = Equipment.find( params[:id] )
	end

end
