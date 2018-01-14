class UserUnitsController < ApplicationController

	before_filter :authenticate_user!
	before_filter :get_unit, except: [ :create, :index ]

	layout 'lifemeter'


	def create
		@unit = current_user.units.new( unit_params )
		
		if @unit.save
			set_flash "Unit Saved"
		else
			set_flash "Unit could not be saved", :danger, @unit
		end
		redirect_to edit_user_unit_path( @unit )
	end

	def destroy
		@unit.destroy
		set_flash "unit Deleted"
		redirect_to user_units_path
	end

	def edit
		@unit.custom_conversion_factor = @unit.conversion_factor 
		@unit.custom_base_unit = @unit.base_unit.try( :name )
	end

	def index
		@units = current_user.units.page( params[:page] )
	end

	def update
		@unit.attributes = unit_params

		custom_base_unit = Unit.find_by_alias( params[:unit][:custom_base_unit].downcase.singularize )

		# special case to disambiguate ounces
		if params[:unit][:unit_type] == 'volume' && params[:unit][:custom_base_unit].match( /ounce|oz/i )
			custom_base_unit = Unit.find_by_alias( 'fl oz' )
		end

		@unit.base_unit = custom_base_unit.try( :base_unit )

		@unit.conversion_factor = ( custom_base_unit.try( :conversion_factor ) || 0 ) * params[:unit][:custom_conversion_factor].to_f

		@unit.save

		if @unit.previous_changes.include?( :base_unit_id ) || @unit.previous_changes.include?( :conversion_factor )
			current_user.observations.where( unit_id: @unit.id ).each do |obs|
				obs.value = obs.value * @unit.conversion_factor 
				obs.save 
			end
			#obs.update_all( value: "value = value * #{@unit.conversion_factor.to_f}" )
		end

		redirect_to :back
	end


	private

		def get_unit
			@unit = current_user.units.friendly.find( params[:id] )
		end

		def unit_params
			params.require( :unit ).permit( :name, :status, :abbrev, :aliases_csv, :metric_id, :unit_type, :conversion_factor, :unit_type, :custom_conversion_factor, :custom_base_unit )
		end

end