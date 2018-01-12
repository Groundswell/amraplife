class UserUnitsController < ApplicationController

	before_filter :authenticate_user!
	before_filter :get_metric, except: [ :create, :index ]

	layout 'lifemeter'


	def create
		@unit = current_user.units.new( unit_params )
		
		if @unit.save
			set_flash "Unit Saved"
		else
			set_flash "Unit could not be saved", :danger, @unit
		end
		redirect_to edit_user_units_path( @unit )
	end

	def destroy
		@unit.destroy
		set_flash "unit Deleted"
		redirect_to user_units_path
	end

	def index
		@units = current_user.units
	end

	def update
		@unit.update( unit_params )
		redirect_to :back
	end


	private

		def get_unit
			@unit = current_user.units.friendly.find( params[:id] )
		end

		def unit_params
			params.require( :unit ).permit( :name, :status, :abbrev, :aliases_csv, :metric_id, :conversion_factor, :unit_type )
		end

end