class CustomUnitsController < ApplicationController

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
		redirect_to edit_custom_unit_path( @unit )
	end

	def destroy
		@unit.destroy
		set_flash "unit Deleted"
		redirect_to custom_units_path
	end

	def edit
		@unit.custom_base_unit_name = Unit.where( id: @unit.custom_base_unit_id ).first.try( :name )
		@unit.conversion_factor = @unit.conversion_factor.to_f
	end

	def index
		@units = current_user.units.page( params[:page] )
	end

	def update

		@unit.attributes = unit_params

		# special case to disambiguate ounces
		if params[:unit][:unit_type] == 'volume' && params[:unit][:custom_base_unit_name].match( /ounce|oz/i )
			params[:unit][:custom_base_unit_name] = 'fl oz'
		end

		custom_base_unit = Unit.where( user_id: current_user.id ).find_by_alias( params[:unit][:custom_base_unit_name].downcase.singularize ) || Unit.system.find_by_alias( params[:unit][:custom_base_unit_name].downcase.singularize )

		@unit.unit_type = custom_base_unit.unit_type if Unit.unit_types[@unit.unit_type] < 1

		# for display, save the custom unit base
		@unit.custom_base_unit_id = custom_base_unit.id if custom_base_unit.present?

		# the real base unit is the system base unit
		@unit.base_unit = custom_base_unit.try( :base_unit ) || Unit.system.where( unit_type: Unit.unit_types[params[:unit][:unit_type]] ).where( base_unit_id: nil ).first

		@unit.conversion_factor = ( ( custom_base_unit.try( :conversion_factor ) || 1 ) * params[:unit][:custom_conversion_factor].to_f )

		@unit.save

		if ( @unit.previous_changes.include?( :base_unit_id ) || @unit.previous_changes.include?( :custom_conversion_factor ) )# && not( @unit.conversion_factor_was == 1.0 )
			die
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
			params.require( :unit ).permit( :name, :status, :abbrev, :aliases_csv, :metric_id, :unit_type, :unit_type, :custom_conversion_factor, :custom_base_unit_name )
		end

end