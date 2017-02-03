class EquipmentController < ApplicationController
	before_action :set_equipment, only: [:show, :edit, :update, :destroy]

	
	def create
		@equipment = Equipment.new( equipment_params )
		@equipment.save
		redirect_to :back
	end

	def destroy
		@equipment.destroy
		redirect_to equipments_url
	end

	def edit
	end

	def new
		@equipment = Equipment.new
	end

	def index
		@equipment = Equipment.all
	end

	def show
	end


	def update
		@equipment.update( equipment_params )
		redirect_to :back
	end


  private
	# Use callbacks to share common setup or constraints between actions.
	def set_equipment
		@equipment = Equipment.find( params[:id] )
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def equipment_params
		params.require( :equipment ).permit( :title, :description )
	end
end
