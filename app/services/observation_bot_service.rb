class ObservationBotService < AbstractBotService

	 add_intents( {

 		assign_metric: {
			utterances: [
				'(?:that)?\s*(?:i)?\s*(?:want)?\s*(?:to)?\s*track {action}',
			],
			slots: {
				action: 'Action',
				unit: 'Unit',
			}
		},

		#todo -- collapse tell_about into this method
 		check_metric: {
			utterances: [
				'(to)?\s*check\s*(my)?\s*{action}',
				'how (much|many) {action} do I have left',
				'how is\s*(my)?\s*{action}',
				'how\'s\s*(my)?\s*{action}',
				'hows\s*(my)?\s*{action}',
				 ],
			slots: {
				action: 'Action',
			}
		},

		log_ate_observation: {
			utterances: [
				'(?:i)?\s*ate {value}\s*{unit} of {action}', # e.g. 30 grams of protein
				'(?:i)?\s*ate {value}\s*{unit}', # e.g. 480 calories
				'(?:i)?\s*ate {value}\s*', # e.g. ate 300 defaults to calories
			],
			slots: {
				action: 'Action',
				value: 'Amount',
				unit: 'Unit',
			}
		},

		log_drink_observation:{
			utterances: [
				'(?:that)?(?:i)?\s*(drank|drink)\s*{value}\s*{action}',
				'(?:that)?(?:i)?\s*(drank|drink)\s*{value}\s*{unit}\s*(?:of)?\s*{action}',
				'(?:that)?(?:i)?\s*(drank|drink)\s*{unit}\s*(?:of)?\s*{action}',
			],
			slots: {
				action: 'Action',
				value: 'Amount',
				unit: 'Unit',
			},
		},


		log_journal_observation: {
			utterances: [
				'(?:to)?\s*journal\s*(that)?{notes}',
				'(?:to)?\s*note\s*(that)?{notes}',
				'(?:to)?\s*take\s*(?:a)?\s*note\s*(that)?{notes}',
				'dear diary\s*{notes}',
			],
			slots: {
				notes: 'Notes',
			}
		},

		log_start_observation: {
			utterances: [
				# (that) (i) (am) start(ed|ing) (to) working
				'(?:to)?(?:that )?\s*(?:i )?\s*(?:am )?\s*(start|tim)(?:ed|ing)?\s*(?:to )?\s*(?:a |an )?\s*{action}',
			],
			slots: {
				action: 'Action',
			}
		},

		log_stop_observation: {
			utterances: [
				"(?:to )?\s*(?:that )?\s*(?:i )?\s*(stop|end|finish|complete)(?:ed|ing|ped)?\s*(?:my)?\s*{action}\s*(?:timer)?",
			],
			slots: {
				action: 'Action',
			}
		},


 		set_target:{
 			utterances: [
 				'set\s+(a\s+)?target\s+for\s+{action}',
 				'set\s+(a\s+)?target\s+of\s+{value}\s*(?:{unit})?\s+for\s+{action}',
 				'set\s+(a\s+)?target\s+of\s+{target_direction}\s+{value}\s*(?:{unit})?\s+for\s+{action}',

 				# # set a target for metric -- uses system metric for defaults
 				# 'set\s+(a\s+)?target\s+for\s+{action}',
 				# # set a target of 100 for metric
 				# 'set\s+(a\s+)?target\s+of\s+{value}\s+for\s+{action}',
 				# # set a target of 100kgs for metric
 				# 'set\s+(a\s+)?target\s+of\s+{value}\s*{unit}\s+for\s+{action}',
 				# # set a target of at least 100kgs for metric
 				# 'set\s+(a\s+)?target\s+of\s+{target_direction}\s+{value}\s*{unit}\s+for\s+{action}',
 				# # set a target of 100kgs per day for metric
 				# 'set\s+(a\s+)?target\s+of\s+{value}\s*{unit}\s+for\s+{action}',


 				# 'set\s+(a\s+)?target\s+of\s+{target_direction}\s+{value}\s+{unit}\s+{target_type}\s+{target_period}for\s+{action}',
 				# 'set\s+(a\s+)?target\s*(for\s+)?{action}\s+of\s+{target_direction}\s+{value}\s+{unit}\s+{target_type}\s+{target_period}',

 				# 'set\s+(a\s+)?target\s+of\s+{value}\s+for\s+{action}',
 				# 'set\s+(a\s+)?target\s+of\s+{value}\s+{unit}\s+for\s+{action}',
 				# 'set\s+(a\s+)?target\s*(for\s+)?{action}\s+of\s+{value}',
 				# 'set\s+(a\s+)?target\s*(for\s+)?{action}\s+of\s+{value}\s*{unit}',
 				# 'set\s+(a\s+)?{action}\s+target\s+of\s+{value}\s+{unit}',
 				# 'set\s+(a\s+)?{action}\s+target\s+of\s+{value}',
 			],
 			slots:{
 				action: 'Action',
 				value: 'Amount',
 				unit: 'Unit',
 				target_direction: 'TargetDirection',
 				target_period: 'TargetPeriod',
 				target_type: 'TargetType'
 			},
 		},

		tell_about: {
			utterances: [
				'(to)?\s*tell\s*(?:me)?\s*about\s*(?:my)?\s*{action}',
				'(to)?\s*tell\s*(?:me)?\s*about\s*(?:my)?\s*{action}\s+{time_period}',
				],
			slots:{
				action: 'Action',
				time_period: 'TimePeriod',
			},
		},


		# catch-all at the bottom. Try to log an observation for unmatched
		log_metric_observation: {
			utterances: [
				
				# for input like....
				# log weight = 176
				# log weight is 176
				# to log that wt is 194
				# weight 179lbs
				'(?:to )?\s*(?:log |record )?\s*(?:that )?\s*{action}\s*(?:=|is|was)?\s*{value}',
				'(?:to )?\s*(?:log |record )?\s*(?:that )?\s*{action}\s*(?:=|is|was)?\s*{value}\s*{unit}',

				# for input like....
				# log 172 for weight
				'(?:to )?\s*(?:log |record )?\s*{value} for {action}',
				'(?:to )?\s*(?:log |record )?\s*{value}\s*{unit} for {action}',

				# for input like....
				# log 10 for sleep OR log 10 hours of sleep
				'(?:to )?\s*(?:log |record )?\s*{value} of {action}',
				'(?:to )?\s*(?:log |record )?\s*{value}\s*{unit} of {action}',

				# for input like....
				# I ran 3 miles
				'(?:that )?\s*i {action} {value}',
				'(?:that )?\s*i {action} {value}\s*{unit}',
				'(?:that )?\s*i {action} for {value}',
				'(?:that )?\s*i {action} for {value}\s*{unit}',

				'(?:that )?\s*i {action} for {duration}',

				'(?:that )?\s*i did {value}\s*{unit} of {action}',

				'my {action} is {value} {unit}',
				'my {action} is {value}',

			],
			slots: {
				value: 'Amount',
				action: 'Action',
				unit: 'Unit',
				duration: 'Notes'
			}
		}
		

	} )

	add_slots( {
		Action: {
			regex: [
				'[a-zA-Z\s,\-]*[a-zA-Z]+'
			],
			values: [
		        { value: "ran", synonyms: [] },
		        { value: "swam", synonyms: [] },
		        { value: "biked", synonyms: [] },
		        { value: "walked", synonyms: [] },
		        { value: "jogged", synonyms: [] },
		        { value: "slept", synonyms: [] },
		        { value: "drove", synonyms: [] },
		        { value: "drive", synonyms: [] },
		        { value: "worked", synonyms: [] },
		        { value: "ate", synonyms: [] },
		        { value: "studying latin", synonyms: [] },
		        { value: "bike ride", synonyms: [] },
			]
		},
		Amount: {
			regex: [
				'[0-9.:&]+'
			],
			values: [
			]
		},
		Duration: {
			regex: [
				'for.*\z'
			],
			values: [
			]
		},
		Food: {
			regex: [
				'[a-zA-Z\.]*\s*[a-zA-Z\.]*\s*[a-zA-Z\.]*\s*[a-zA-Z\.]*\s*[a-zA-Z\.]+'
			],
			values: [
			]
		},
		Measure: {
			regex: [
				'[a-zA-Z]+'
			],
			values: [
		        { value: "cup", synonyms: [] },
		        { value: "gram", synonyms: [] },
		        { value: "teaspoon", synonyms: [] },
		        { value: "tablespoon", synonyms: [] },
		        { value: "liter", synonyms: [] },
		        { value: "ounce", synonyms: [] },
			]
		},
		Name: {
			regex: [
				'.+'
				],
				values: []
		},
		Notes: {
			regex: [
				'.+\z'
				],
				values: []
		},
		
		TargetDirection: {
			regex: [
				'(at least|at most|exactly|minimum|maximum)'
				],
				values: []
		},

		TargetPeriod: {
			regex: [
				'(per day|per week|per month|daily|weekly|monthly|forever|all time|all-time)'
				],
				values: []
		},

		TargetType: {
			regex: [
				'(total|average|count)'
				],
				values: []
		},

		Unit: {
			regex: [
				'(?:a )?[a-zA-Z]+'
			],
			values: [
				{ value: "g", synonyms: [] },
		        { value: "kg", synonyms: [] },
		        { value: "in", synonyms: [] },
		        { value: "cm", synonyms: [] },
		        { value: "mile", synonyms: [] },
		        { value: "cal", synonyms: [] },
		        { value: "calorie", synonyms: [] },
		        { value: "km", synonyms: [] },
		        { value: "sec", synonyms: [] },
		        { value: "kilometer", synonyms: [] },
		        { value: "%", synonyms: [] },
		        { value: "lb", synonyms: [] },
		        { value: "pound", synonyms: [] },
		        { value: "rd", synonyms: [] },
		        { value: "rep", synonyms: [] },
	      ]
	  },
  	} )



	def assign_metric
		unless user.present?
			call_intent( :login )
			return
		end

		metric = get_user_metric( user, params[:action], nil, true )

		response = "Great, I've added #{metric.title}. You can start logging it by saying '#{metric.title} is some value.'"
		add_speech( response )

		user.user_inputs.create( content: raw_input, result_obj: metric, action: 'created', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{response}'" )
	end

	def check_metric
		# todo
		unless user.present?
			call_intent( :login )
			return
		end

		metric = get_user_metric( user, params[:action], nil, false )

		if metric.nil?
			default_metric ||= Metric.where( user_id: nil ).find_by_alias( params[:action].downcase )
			action = default_metric.try( :title ) || params[:action]
			add_speech("Sorry, you haven't recorded anything for #{action} yet.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, you haven't recorded anything for #{action} yet.'" )
			return
		end

		if metric.active_target.present?
			if metric.active_target.target_type == 'value'
				current = metric.observations.order( created_at: :desc ).first.value
			else
				case metric.active_target.period
				when 'daily'
					range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
					target_period = 'per day'
					current_period = 'today'
				when 'weekly'
					range = Time.zone.now.beginning_of_week..Time.zone.now.end_of_day
					target_period = 'per week'
					current_period = 'this week'
				when 'monthly'
					range = Time.zone.now.beginning_of_month..Time.zone.now.end_of_day
					target_period = 'per month'
					current_period = 'this month'
				when 'yearly'
					range = Time.zone.now.beginning_of_year..Time.zone.now.end_of_day
					target_period = 'per year'
					current_period = 'this year'
				else
					range = "2001-01-01".to_date..Time.zone.now.end_of_day
					target_period = ''
					current_period = ''
				end

				case metric.active_target.target_type
				when 'sum_value'
					current = metric.observations.where( recorded_at: range ).sum( :value )
					target_type = "total"
				when 'count'
					current = metric.observations.where( recorded_at: range ).count
					target_type = "observations"
				when 'avg_value'
					current = metric.observations.where( recorded_at: range ).average( :value )
					target_type = "average"
				end

			end

			formatted_target = metric.active_target.unit.convert_from_base( metric.active_target.value, show_units: true ) #UnitService.new( val: metric.target, unit: metric.unit, disp_unit: metric.display_unit, use_metric: user.use_metric, show_units: true ).convert_to_display

			formatted_current = metric.unit.convert_from_base( current, show_units: true ) #UnitService.new( val: current, unit: metric.unit, disp_unit: metric.display_unit, use_metric: user.use_metric, show_units: true ).convert_to_display

			delta = current - metric.active_target.value
			formatted_delta = metric.unit.convert_from_base( delta.abs, show_units: true )# UnitService.new( val: delta.abs, unit: metric.unit, disp_unit: metric.display_unit, use_metric: user.use_metric, show_units: true ).convert_to_display
			
			direction = delta > 0 ? 'over' : 'under'

			if metric.active_target.target_type == 'value'
				response = "You have a target of #{metric.active_target.direction.gsub( /_/, ' ' )} #{formatted_target}. Your most recent #{metric.title} is #{formatted_current}. "
				response += "You are #{direction} your target by #{formatted_delta}."
			else
				response = "You have a target of #{metric.active_target.direction.gsub( /_/, ' ' )} #{formatted_target} #{target_type} #{target_period}. Your #{target_type} so far #{current_period} is #{formatted_current}. "
				response += "You are #{direction} your target by #{formatted_delta}."
			end


		else
			last_observation = metric.observations.order( created_at: :desc ).first
			formatted_last = metric.unit.convert_from_base( last_observation.value, show_units: true )
			total = metric.observations.where( recorded_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day ).sum( :value )
			formatted_total = metric.unit.convert_from_base( total, show_units: true ) #UnitService.new( val: total, unit: metric.unit, disp_unit: metric.display_unit, use_metric: user.use_metric ).convert_to_display
			response = "You haven't set a target for #{metric.title} yet. You last recorded #{formatted_last} at #{last_observation.recorded_at.to_s( :long )}. You have logged #{formatted_total} total so far today."
		end

		add_speech( response )

		user.user_inputs.create( content: raw_input, action: 'reported', source: options[:source], result_status: 'success', system_notes: "Spoke: #{response}" )

	end


	def log_ate_observation

		unless user.present?
			call_intent( :login )
			return
		end


		if params[:value].blank?# || ( params[:action].blank? && params[:unit].blank? )

			add_ask( "I'm sorry, I didn't understand that.  You must supply a unit or action with your value in order to log it.  For example \"I ate one hundred calories\" or \"I ate 12 grams of sugar\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply a unit or action with your value in order to log it.", deligate_if_possible: true )
			return

		end

		# @todo parse notes
		notes = @raw_input
		sys_notes = nil


		# trim the unit
		unit = params[:unit].chomp( '.' ).singularize if params[:unit].present?

		action = params[:action].gsub( /(log|record|to |my | todays | is| are| was| = |i | for)/i, '' ).strip if params[:action].present?

		action ||= unit 

		action ||= 'cal'

		# fetch the metric
		if metric = get_user_metric( user, action, unit, true )

			user_unit = Unit.find_by_alias( unit ) || metric.unit

			if user_unit.present?
				val = params[:value].to_f * user_unit.conversion_factor
			else
				val = params[:value].to_f
			end

			observation = user.observations.create( observed: metric, value: val, unit: user_unit, notes: notes )
			add_speech( observation.to_s( user ) )
		else
			add_ask( "I'm sorry, I didn't understand that.  You must supply a unit or action with your value in order to log it.  For example \"I ate one hundred calories\" or \"I ate 16 grams of sugar\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply a unit or action with your value in order to log it.", deligate_if_possible: true )
			return
		end


		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: "Logged #{observation.display_value( show_units: true )} for #{observation.observed.try(:title) || params[:action]}." )

	end


	def log_drink_observation
		unless user.present?
			call_intent( :login )
			return
		end

		user_unit = params[:unit]

		# todo -- this breaks coffee
		if params[:action].match( /of/ )
			metric_alias = params[:action].gsub( /.+of/, '' ).strip
			user_unit ||= params[:action].split( /of/ )[0].strip.singularize
		else
			metric_alias = params[:action].gsub( /\S+\s/, '' ).strip.singularize
			user_unit ||= params[:action].match( /\S+\s/ ).to_s.strip.singularize
		end

		# fetch the metric
		metric = get_user_metric( user, metric_alias, 'l', true )

		# invocations like 'a cup of milk' leave value params nil
		# we';ll assume one unless given a number like
		# 3 pints of beer
		params[:value] ||= 1

		# take out leading "a " or "an " so "a cup" becomes "cup"
		user_unit.gsub!( /(\Aa.*\s)/i, '' )


		if [ 'ounce', 'oz'].include?( :user_unit )
			user_unit = 'fl oz'
		end

		unit = Unit.find_by_alias( user_unit ) || metric.unit

		val = params[:value].to_f * unit.conversion_factor

		observation = user.observations.create( observed: metric, value: val, unit: unit, notes: @raw_input )


		add_speech( observation.to_s( user ) )
		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: "Logged #{observation.display_value( show_units: true )} for #{observation.observed.title}." )
	end


	def log_journal_observation
		unless user.present?
			call_intent( :login )
			return
		end

		if params[:notes].present?
			observation = user.observations.create( notes: params[:notes] )
			add_speech( "I recorded your journal entry." )
			user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: "Spoke: 'I recorded your journal entry.'" )
		end
	end

	def log_start_observation
		unless user.present?
			call_intent( :login )
			return
		end


		if params[:action].blank?

			add_ask( "I'm sorry, I didn't understand that.  You must supply an action in order to start a timer.  For example \"start jogging timer\" or \"start bike ride\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply an action in order to start a timer.", deligate_if_possible: true )
			return

		end

		# @todo parse notes
		notes = @raw_input

		params[:action] = params[:action].gsub( /timer/, '' )

		metric = get_user_metric( user, params[:action], 's', true )

		observation = Observation.create( user: user, observed: metric, started_at: Time.zone.now, notes: notes )
		add_speech("Starting your #{metric.title} timer")

		sys_notes = "Spoke: 'Starting your #{metric.title} timer'."

		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: sys_notes )

	end

	def log_stop_observation
		unless user.present?
			call_intent( :login )
			return
		end


		if params[:action].blank?

			add_ask( "I'm sorry, I didn't understand that.  You must supply an action in order to stop a timer.  For example \"stop jogging timer\" or \"stop bike ride\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply an action in order to stop a timer.", deligate_if_possible: true )
			return

		end

		notes = @raw_input
		sys_notes = ''

		metric = get_user_metric( user, params[:action], 's' )

		if metric.nil?
			default_metric ||= Metric.where( user_id: nil ).find_by_alias( params[:action].downcase )
			action = default_metric.try( :title ) || params[:action]
			add_speech("Sorry, you haven't recorded anything for #{action} yet.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, you haven't recorded anything for #{action} yet.'" )
			return
		end

		observations = user.observations.of( metric ).where( value: nil ).where( 'started_at is not null' ).order( started_at: :desc )
		observation  = observations.first

		if observation.present?
			observation.stop!

			if observation.notes.present?
				observation.notes = "#{observation.notes}\r\n#{notes}"
			else
				observation.notes = notes
			end

			observation.save
			add_speech("Stopping your #{metric.title} timer at #{observation.value.to_i} #{observation.unit}" )
			sys_notes = "Spoke: 'Stopping your #{metric.title} timer at #{observation.value.to_i} #{observation.unit}'"
		else
			add_speech("I can't find any running #{params[:action]} timers.")
			sys_notes = "I can't find any running #{params[:action]} timers."
		end

		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'updated', source: options[:source], result_status: 'success', system_notes: sys_notes )

	end


	def set_target
		unless user.present?
			call_intent( :login )
			return
		end

		unless params[:action].present?
			add_ask("Sounds like you were trying to set a target, but I didn't catch what it was.  Next time be sure to specify what it is you want to track.  For example \"set a target of one thousand eight hundred for calories\".  Now give it another try.", reprompt_text: "I still didn't understand that.  To set a target you must specify what it is you want to track, and what your goal is.", deligate_if_possible: true )
			return
		end

		metric = get_user_metric( user, params[:action], params[:unit], true )

		system_metric = Metric.where( user_id: nil ).find_by_alias( params[:action].singularize.downcase )
		system_metric ||= Metric.where( user_id: nil ).find_by_alias( params[:unit] ).try( :singularize ).try( :downcase )

		system_target = system_metric.targets.where( user_id: nil ).first

		value = params[:value] || system_target.value
		if params[:unit].present?
			unit = Unit.find_by_alias( params[:unit].singularize )
		end 
		unit ||= metric.unit 

		direction = params[:target_direction].try( :downcase )
		direction.gsub( /\s+/, '_' ) if direction.present?
		direction = 'at_least' if direction == 'minimum'
		direction = 'at_most' if direction == 'maximum'
		direction ||= system_target.direction 
		
		period = params[:target_period] || system_target.period 
		type = params[:target_type] || system_target.target_type

		target = metric.targets.where( user: user ).last || metric.targets.new( user: user )

		target.unit = unit
		target.direction = direction
		target.period = period
		target.target_type = type
		target.value = metric.unit.convert_to_base( value )

		target.save

		disp_value = target.unit.convert_from_base( target.value )


		response = "I set a target of #{Target.directions[target.direction]} #{disp_value} #{Target.periods[target.period]} for #{metric.title}."
		add_speech( response )

		user.user_inputs.create( content: raw_input, result_obj: metric, action: 'updated', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{response}'" )

	end
	

	def tell_about
		unless user.present?
			call_intent( :login )
			return
		end
		metric = get_user_metric( user, params[:action] )

		if metric.nil?
			default_metric ||= Metric.where( user_id: nil ).find_by_alias( params[:action].downcase )
			action = default_metric.try( :title ) || params[:action]
			add_speech("Sorry, you haven't recorded anything for #{action} yet.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, you haven't recorded anything for #{action} yet.'" )
			return
		end

		obs_count_total = user.observations.for( metric ).count
		obs_count_last_week = user.observations.for( metric ).where( recorded_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week ).count
		obs_count_this_week = user.observations.for( metric ).where( recorded_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week ).count

		average_value = user.observations.for( metric ).average( :value ).try( :round, 2 ) || 0
		min_value = user.observations.for( metric ).minimum( :value ) || 0
		max_value = user.observations.for( metric ).maximum( :value ) || 0
		value_sum = user.observations.for( metric ).sum( :value ) || 0
		recent_value = user.observations.for( metric ).order( created_at: :desc ).first.value

		formatted_average = metric.unit.convert_from_base( average_value )

		formatted_min = metric.unit.convert_from_base( min_value )
		formatted_max = metric.unit.convert_from_base( max_value )
		formatted_sum = metric.unit.convert_from_base( value_sum )
		formatted_recent = metric.unit.convert_from_base( recent_value )

		response = "You have logged #{metric.title} #{obs_count_total} times in all. #{obs_count_last_week} times last week, and #{obs_count_this_week} times so far this week. Your all-time total is #{formatted_sum}. The average value for #{metric.title} is #{formatted_average}. The max value is #{formatted_max} and the minimum is #{formatted_min}. The most recent recorded value is #{formatted_recent}."
		add_speech( response )


		user.user_inputs.create( content: raw_input, action: 'reported', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{response}'." )

	end



	

	def log_metric_observation
		unless user.present?
			call_intent( :login )
			return
		end


		if params[:action].blank?
			add_ask( "I'm sorry, I didn't understand that.  I don't know what to log. You must supply an action with your value in order to log it.  For example \"log one hundred calories\" or \"my weight is one hundred sixty\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply a unit or action with your value in order to log it.", deligate_if_possible: true )
			return

		elsif params[:duration].blank? && params[:value].blank? && params[:unit].blank?
			add_ask( "I'm sorry, I didn't understand that.  You must supply a unit or value with your action in order to log it.  For example \"log one hundred calories\" or \"my weight is one hundred sixty\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply a unit or action with your value in order to log it.", deligate_if_possible: true )
			return
		end

		# @todo parse notes
		notes = @raw_input
		sys_notes = nil
		# trim the unit
		unit = params[:unit].chomp( '.' ).singularize if params[:unit].present?

		action = params[:action].gsub( /(log|record|to |my | todays | is| are| was| = |i | for)/i, '' ).strip if params[:action].present?


		# fetch the metric
		if metric = get_user_metric( user, params[:action], unit, true )

			if params[:duration].present?
				val = ChronicDuration.parse( params[:duration] )
				user_unit = Unit.find_by_alias( 's' )
			else

				user_unit = Unit.find_by_alias( unit ) || metric.unit

				if user_unit.present?
					val = user_unit.convert_to_base( params[:value] )
				else
					val = params[:value].to_f
				end
			end

			observation = user.observations.create( observed: metric, value: val, unit: user_unit, notes: notes )
			add_speech( observation.to_s( user ) )
		else
			add_ask( "I'm sorry, I didn't understand that.  You must supply a unit or action with your value in order to log it.  For example \"log one hundred calories\" or \"my weight is one hundred sixty\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply a unit or action with your value in order to log it.", deligate_if_possible: true )
			return
		end


		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: "Logged #{observation.display_value( show_units: true )} for #{observation.observed.try(:title) || params[:action]}." )

	end

	
	def stop
		add_speech("Stopping.")
		add_clear_audio_queue()
	end

	






	private

		def get_user_metric( user, action, unit=nil, create=false )

			if action.present?
				
				# clean up the action string... some of our matchers leave cruft
				action = action.gsub( /(log|record|to |my | todays | is| are| was| = |i | for|timer)/i, '' ).strip

				# first, check the user's existing assigned metrics. Return that if exists...
				if user.metrics.find_by_alias( action.downcase )
					return user.metrics.find_by_alias( action.downcase )
				end
				# also check the user's existing assigned metrics based on unit that if exists...
				if user.metrics.find_by_alias( unit.try( :downcase ) )
					return user.metrics.find_by_alias( unit.downcase )
				end

				# if we didn't find it in the user's assigned metric list, and create option is invoked...
				if create
					# check the system default metrics
					system_metric = Metric.where( user_id: nil ).find_by_alias( action.downcase )
					system_metric ||= Metric.where( user_id: nil ).find_by_alias( unit.try( :downcase ) )

					if system_metric.present?
						# assign with default display units based on the user's preference
						observed_metric ||= system_metric.dup
						observed_metric.user = user

						#if not( user.use_metric? ) && not( system_metric.metric_type == 'nutrition' ) # hack to keep from converting grams of nutrient to ounces
							#if UnitService::METRIC_TO_IMPERIAL_MAP[ observed_metric.display_unit ].present?
							#	observed_metric.display_unit = UnitService::METRIC_TO_IMPERIAL_MAP[ observed_metric.display_unit ]
							#end
						#end

						# convert unit user gave us to base correct unit
						if users_unit = Unit.find_by_alias( unit )
							observed_metric.unit = users_unit
						elsif user.use_imperial_units?
							# didn't get a unit from the user... translate to their preference
							# by default, system metric units are metric
							observed_metric.unit = observed_metric.unit.imperial_correlate || observed_metric.unit
						end

						observed_metric.save
						return observed_metric
					else
						# gotta make a new metric from scratch
						observed_metric ||= Metric.new( title: action )
						
						if users_unit = Unit.find_by_alias( unit )
							observed_metric.unit = users_unit
						elsif unit.present?
							observed_metric.unit = Unit.create( user_id: user.id, name: unit, abbrev: unit )
						end

						observed_metric.user = user
						if observed_metric.save
							return observed_metric
						else
							return false
						end
					end
				end

			else
				# no action, nothing to do
				return nil
			end

		end

end
