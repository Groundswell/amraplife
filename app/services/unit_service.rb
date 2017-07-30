class UnitService

	# translation of observed units into base units as stored in the DB
	STORED_UNIT_MAP = {
		# all distance/lengths are in meters
		'in' 	=> 'm',
		'yd' 	=> 'm',
		'mi' 	=> 'm',
		'cm'	=> 'm',
		'm' 	=> 'm',
		'km' 	=> 'm',

		# all weights are in grams
		'ounce' => 'g',
		'lb' 	=> 'g',
		'g' 	=> 'g',
		'kg'	=> 'g',

		# all volumes in liters
		'fluid ounce' 	=> 'l',
		'cup' 			=> 'l',
		'pint' 			=> 'l',
		'quart' 		=> 'l',
		'gallon' 		=> 'l',
		'ml' 			=> 'l',
		'l' 			=> 'l'
	}

	METRIC_TYPE_MAP = {
		'Arbitrary' 		=> '',
		'Time' 				=> 's',
		'Length/Distance'	=> 'm',
		'Weight' 			=> 'g',
		'Volume'			=> 'l',
		'Percent' 			=> '%'
	}

	# metric units to their imperial correlates
	METRIC_TO_IMPERIAL_MAP = {
		'cm' => 'in',
		'm' => 'yd', 
		'km' => 'mi',

		'g'  => 'ounce',
		'kg' => 'lb',

		'ml' => 'fluid ounce',
		'l' => 'gallon'
	}

	# imperial units to their metric correlates
	IMPERIAL_TO_METRIC_MAP = {
		'in' => 'cm',
		'yd' => 'm',
		'mi' => 'km',

		'ounce' => 'g',
		'lb' => 'kg',

		'fluid ounce' => 'ml',
		'gallon' => 'l'	
	}

	def translate_to_imperial( unit )
		if METRIC_TO_IMPERIAL_MAP[ unit ].present?
			unit = METRIC_TO_IMPERIAL_MAP[ unit ]
		else
			unit
		end
	end

	def translate_to_metric( unit )
		if IMPERIAL_TO_METRIC_MAP[ unit ].present?
			unit = IMPERIAL_TO_METRIC_MAP[ unit ]
		else
			unit
		end
	end

	def initialize( opts={} )
		@val = opts[:val] || opts[:value]
		
		@stored_unit = opts[:stored_unit] || opts[:base_unit] || opts[:unit]
		
		@user_unit = opts[:display_unit] || opts[:disp_unit] || opts[:user_unit]
		@user_unit = @user_unit.chomp( 's' ).chomp( '.' ) if @user_unit.present?

		@use_metric = opts[:use_metric] || false
		@precision = opts[:precision] || 2
	end

	def convert_to_display
		return nil if @val.nil?

		if @stored_unit == 's'
			return ChronicDuration.output( @val, format: :chrono )
		elsif @stored_unit == '%'
			return "#{( @val * 100.to_f ).round( @precision )}%"
		else
			# if not( @use_metric ) 
			# 	@user_unit = translate_to_imperial( @user_unit )
			# end
			begin
				value = Unitwise( @val, @stored_unit ).convert_to( @user_unit ).to_f.round( @precision )
			rescue
				value = @val
			end
			unless @user_unit.blank?
				return value == 1 ? "#{value} #{@user_unit}" : "#{value} #{@user_unit}s"
			else
				return "#{value}"
			end
		end
	end

	def convert_to_stored_value
		value = @val

		@stored_unit = convert_to_stored_unit if @stored_unit.nil?
		
		if @stored_unit == 's'
			value = ChronicDuration.parse( "#{@val} #{@display_unit}" )

		elsif @stored_unit == '%'
			value = ( @val / 100.to_f ).round( @precision )

		elsif STORED_UNIT_MAP.values.uniq.include?( @stored_unit )
			begin
				value = Unitwise( @val, @user_unit ).convert_to( @stored_unit ).to_f.round( @precision )
			rescue
				value = @val
			end
		end

		return value
	end

	def convert_to_stored_unit
		if STORED_UNIT_MAP[ @user_unit ].present?
			@stored_unit = STORED_UNIT_MAP[ @user_unit ]
		else
			@stored_unit = @user_unit
		end
	end


end