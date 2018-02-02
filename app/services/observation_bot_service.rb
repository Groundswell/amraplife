class ObservationBotService < AbstractBotService

	 add_intents( {

 		assign_metric: {
			utterances: [
				'(?:that)?\s*(?:i)?\s*(?:want)?\s*(?:to)?\s*track my {action} {unit}',
				'(?:that)?\s*(?:i)?\s*(?:want)?\s*(?:to)?\s*track my {action}',
				'(?:that)?\s*(?:i)?\s*(?:want)?\s*(?:to)?\s*track {action} {unit}',
				'(?:that)?\s*(?:i)?\s*(?:want)?\s*(?:to)?\s*track {action}',

				'(?:that)?\s*(?:i)?\s*(?:want)?\s*(?:to)?\s*start tracking my {action} {unit}',
				'(?:that)?\s*(?:i)?\s*(?:want)?\s*(?:to)?\s*start tracking my {action}',
				'(?:that)?\s*(?:i)?\s*(?:want)?\s*(?:to)?\s*start tracking {action} {unit}',
				'(?:that)?\s*(?:i)?\s*(?:want)?\s*(?:to)?\s*start tracking {action}',

				'(?:that)?\s*(?:i)?\s*(?:want)?\s*(?:to)?\s*add metric {action} {unit}',
				'(?:that)?\s*(?:i)?\s*(?:want)?\s*(?:to)?\s*add metric {action}'
			],
			slots: {
				action: 'Action',
				unit: 'Unit',
			}
		},

		#todo -- collapse tell_about into this method
 		check_metric: {
			utterances: [
				'(to)?\s*check\s*(my)?\s*{action}\s*target',
				'(to)?\s*check\s*(my)?\s*{action}',
				'how (much|many) {action} do I have.*',
				'how is\s*(my)?\s*{action} (d|g)oing',
				'how are\s*(my)?\s*{action} (d|g)oing',
				'how is\s*(my)?\s*{action}',
				'how\'s\s*(my)?\s*{action}',
				'hows\s*(my)?\s*{action}',
				'how\s*are\s*(my)?\s*{action}',
				'(to)?\s*tell\s*(?:me)?\s*about\s*(?:my)?\s*{action}',
				'\s*about\s*(?:my)?\s*{action}'
				 ],
			slots: {
				action: 'Action',
			}
		},

		log_ate_food_observation: {
			utterances: [
				'(?:that )?\s*(?:i)?\s*ate {quantity} serving of {food}', # e.g. 1 serving of raisins
				'(?:that )?\s*(?:i)?\s*ate {portion} portion of {food}', # e.g. 1 portion of pie
				'(?:that )?\s*(?:i)?\s*ate a {measure} of {food}', # e.g. a can of soup
				'(?:that )?\s*(?:i)?\s*ate {quantity} {measure} of {food}', # e.g. 1 cup of raisins
				'(?:that )?\s*(?:i)?\s*ate {quantity} {food}', # e.g. 1 apple
			],
			slots: {
				quantity: 'Number',
				food: 'Food',
				measure: 'Measure',
				portion: 'Number',
			}
		},

		log_ate_observation: {
			utterances: [
				# TODO -- {action} is a greedy matcher.... it slurps up time_period & note params
				'(?:that )?\s*(?:i)?\s*ate {value}\s*{unit} of {action}\s*({time_period})?\s*({notes})?', # e.g. 30 grams of protein
				'(?:that )?\s*(?:i)?\s*ate {value}\s*{unit}\s*({time_period})?\s*({notes})?', # e.g. 480 calories
				'(?:that )?\s*(?:i)?\s*ate {value}\s*({time_period})?\s*({notes})?', # e.g. ate 300 defaults to calories

				'(?:that )?\s*(?:i)?\s*have eaten {value}\s*{unit} of {action}\s*({time_period})?\s*({notes})?', # e.g. 30 grams of protein
				'(?:that )?\s*(?:i)?\s*have eaten {value}\s*{unit}\s*({time_period})?\s*({notes})?', # e.g. 480 calories
				'(?:that )?\s*(?:i)?\s*have eaten {value}\s*({time_period})?\s*({notes})?', # e.g. ate 300 defaults to calories
			],
			slots: {
				action: 'Action',
				value: 'Amount',
				unit: 'Unit',
				time_period: 'TimePeriod',
				notes: 'ExplicitNotes'
			}
		},

		log_burned_observation: {
			utterances: [
				'(?:that )?(?:i)?\s*burned {value}\s*{unit}\s*({time_period})?\s*({notes})?', # e.g. burned 250 calories
				'(?:that )?(?:i)?\s*burned {value}\s*({time_period})?\s*({notes})?', # e.g. burned 300 defaults to calories
			],
			slots: {
				unit: 'Unit',
				value: 'Amount',
				time_period: 'TimePeriod',
				notes: 'ExplicitNotes'
			}
		},

		log_drink_observation:{
			utterances: [
				'(?:that)?(?:i)?\s*(drank|drink)\s*{value}\s*{unit}\s+of\s+{action}\s*({time_period})?\s*({notes})?',
				'(?:that)?(?:i)?\s*(drank|drink)\s*{value}\s*{action}\s*({time_period})?\s*({notes})?',

				#'(?:that)?(?:i)?\s*(drank|drink)\s*{unit}\s*(?:of)?\s*{action}',
			],
			slots: {
				action: 'Action',
				value: 'Amount',
				unit: 'Unit',
				time_period: 'TimePeriod',
				notes: 'ExplicitNotes'
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

 				# todo -- send this into a context: e.g. "set a target..." resp: 'ok, for which which metric?' 'how many' etc...
 				# set a target of at most 1500 cals total per day for calories
 				# set a target of at most 185 lbs for weight

 				#'(?:to)?set\s+(a\s+)?(target|goal)\s+of\s*({target_direction})?\s+{value}\s*({unit})?\s*({target_type})?\s*({target_period})?\s*for {action}',

 				'(?:to)?set\s+(a\s+)?(target|goal)\s+of\s+({target_direction})?\s*{value}\s*({unit})?\s*({target_type})?\s*({target_period})?\s* for {action}'
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


		quick_report: {
			utterances: [
				# what was my weight
				# what is my blood pressure
				# what is my max bench
				'what\s+{verb}\s*(?:my)?\s*{action}\s*{report_period}',
				'what\s+{verb}\s*(?:my)?\s*{action}',

				# how much do i weigh

				# how long did i swim
				# how much beer did i drink

				# how many calories did i eat
				# how many minutes did i work out
				'how\s+(much|many|long)\s+{verb}?\s*{action}\D*{report_period}',
				'how\s+(much|many|long)\s+{verb}?\s*{action}\D*',

				],
			slots:{
				action: 'Action',
				verb: 'Verb',
				report_period: 'TimePeriod'
			},
		},


		# catch-all at the bottom. Try to log an observation for unmatched
		log_metric_observation: {
			utterances: [

				# 	utterances ending with an {action} don't get the \s*({time_period})?\s*({notes})? treatment
				# 	cause their going to greedy-match to end of string anyway (unless there's a number of symbol in there)


				# special duration catcher
				# only works for
				'(?:to )?\s*(?:log |record )?\s*(?:that )?\s*(?:i )?\s*{action} (for )?\s*{duration}\s*({time_period})?\s*({notes})?',

				# 	for input like....
				# 	log weight = 176
				# 	log weight is 176
				# 	to log that wt is 194
				# 	log that my weight was 176
				# 	weight 179lbs
				#'(?:to )?\s*(?:log |record )?\s*(?:that )?\s*(?:my )?\s*{action}\s*(?:=|is|was)?\s*{value}\s*({time_period})?\s*({notes})?',
				'(?:to )?\s*(?:log |record )?\s*(?:that )?\s*(?:i )?\s*(?:my )?\s*{action}\s*(:|=|is|was|are|were|equal)\s*{value}\s*({unit})?\s*({time_period})?\s*({notes})?',



				# # 	for input like....
				# # 	log 172 for weight
				'(?:to )?\s*(?:log |record )?\s*{value}\s*({unit})? (for|of) (my)?\s*{action}\s*({time_period})?\s*({notes})?',




				# # 	for input like....
				# # 	actions that are verbs
				# # 	I ran 3 miles

				'(?:to )?\s*(?:log |record )?\s*(?:that )?\s*(?:i )?\s*{action} for {value}\s*({unit})?\s*({time_period})?\s*({notes})?',
				'(?:to )?\s*(?:log |record )?\s*(?:that )?\s*(?:i )?\s*{action} {value}\s*({unit})?\s*({time_period})?\s*({notes})?',


				# '(?:that )?\s*i (did)?\s*{action} for {value}\s*({time_period})?\s*({notes})?',
				# '(?:that )?\s*i (did)?\s*{action} for {value}\s*{unit}\s*({time_period})?\s*({notes})?',


				# # 	for input like....

				# # 	did 30 minutes of cardio
				# #  	MUST use 'of' to separate units from action
				'(?:to )?\s*(?:log |record )?\s*(?:that )?\s*(?:i )?\s*did {value} {unit} of {action}\s*({time_period})?\s*({notes})?',
				# # 	did 100 pullups
				# # 	NO Unit
				'(?:to )?\s*(?:log |record )?\s*(?:that )?\s*(?:i )?\s*did {value} {action}\s*({time_period})?\s*({notes})?',

				# # 	10 pushups, 300 calories,
				'(?:to )?\s*(?:log |record )?\s*{value} {action}\s*({time_period})?\s*({notes})?',

				# '(?:to )?\s*(?:log |record ){value} {action}'

			],
			slots: {
				value: 'Amount',
				action: 'Action',
				unit: 'Unit',
				duration: 'Duration',
				time_period: 'TimePeriod',
				notes: 'ExplicitNotes'
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
				'[0-9.:&|\s+a\s+|\s+an\s+]+'
			],
			values: [
			]
		},
		Duration: {
			regex: [
				'\d+\s+hour(s)?\s*(and)?\s*\d+\s+minute(s)?\s*(and)?\s*\d+\s+second(s)?',
				'\d+\s+hour(s)?\s*(and)?\s*\d+\s+minute(s)?',
				'\d+\s+minute(s)?\s*(and)?\s*\d+\s+second(s)?',
				'\d+\s+(second|minute|hour|day)',
				'\d+:\d+:\d+',
				'\d+:\d+',
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
		ExplicitNotes: {
			regex: [
				'note.+\z'
				],
				values: []
		},
		TimePeriod: {
			regex: [
				'for breakfast|for lunch|for dinner|for snack|this morning|this afternoon|this evening|tonight|today|yesterday|last night|this week|last week|this month|last month|this year|last year|in the past \d+ hour|in the last \d+ hour|in the past \d+ day|in the last \d+ day|in the past \d+ week|in the last \d+ week|in the past \d+ month|in the last \d+ month|in the past year|in the last year|\d+ hour(s)? ago|\d+ day(s)? ago|\d+ week(s)? ago|\d+ month(s)? ago'
				],
				values: []
		},

		TargetDirection: {
			regex: [
				'at least|at most|exactly|min|max|minimum|maximum'
				],
				values: []
		},

		TargetPeriod: {
			regex: [
				'per hour|per day|per week|per month|per year|daily|weekly|monthly|yearly|forever|all time|all-time'
				],
				values: []
		},

		TargetType: {
			regex: [
				'total|average|avg|count|checkin|observation|times'
				],
				values: []
		},
		Unit: {
			regex: [
				'(?:a )?[a-zA-Z\"\'%#"]+'
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
	  Verb: {
			regex: [
				'is|are|was|were|do i|did i|did i do'
				],
				values: []
		},
  	} )



	def assign_metric
		unless user.present?
			call_intent( :login )
			return
		end

		unit = params[:unit].try( :singularize ) || nil

		metric = get_user_metric( user, params[:action], unit, true )

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

		action = params[:action].singularize.downcase

		metric = get_user_metric( user, action, nil, false )

		if metric.nil?
			default_metric ||= Metric.where( user_id: nil ).find_by_alias( action )
			action = default_metric.try( :title ) || params[:action]
			add_speech("Sorry, you haven't recorded anything for #{action} yet.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, you haven't recorded anything for #{action} yet.'" )
			return
		end

		same_type_unit_ids = Unit.where( unit_type: Unit.unit_types[metric.unit.unit_type] ).pluck( :id )

		if metric.active_target.present?
			if metric.active_target.target_type == 'current_value'
				current = metric.observations.where( unit_id: same_type_unit_ids ).order( created_at: :desc ).first.value
			else
				case metric.active_target.period
				when 'day'
					range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
					target_period = 'per day'
					current_period = 'today'
				when 'week'
					range = Time.zone.now.beginning_of_week..Time.zone.now.end_of_day
					target_period = 'per week'
					current_period = 'this week'
				when 'month'
					range = Time.zone.now.beginning_of_month..Time.zone.now.end_of_day
					target_period = 'per month'
					current_period = 'this month'
				when 'year'
					range = Time.zone.now.beginning_of_year..Time.zone.now.end_of_day
					target_period = 'per year'
					current_period = 'this year'
				else # forever
					range = "2001-01-01".to_date..Time.zone.now.end_of_day
					target_period = ''
					current_period = ''
				end

				case metric.active_target.target_type
				when 'sum_value'
					current = metric.observations.where( unit_id: same_type_unit_ids ).where( recorded_at: range ).sum( :value )
					target_type = "total"
				when 'count'
					current = metric.observations.where( recorded_at: range ).count
					target_type = "observations"
				when 'avg_value'
					current = metric.observations.where( unit_id: same_type_unit_ids ).where( recorded_at: range ).average( :value )
					target_type = "average"
				when 'max_value'
					current = metric.observations.where( unit_id: same_type_unit_ids ).where( recorded_at: range ).maximum( :value )
					target_type = "max"
				when 'min_value'
					current = metric.observations.where( unit_id: same_type_unit_ids ).where( recorded_at: range ).minimum( :value )
					target_type = "min"
				end


			end

			delta = current - metric.active_target.value

			unless metric.active_target.target_type == 'count'
				formatted_target = metric.active_target.unit.convert_from_base( metric.active_target.value, show_units: true )
				formatted_current = metric.unit.convert_from_base( current, show_units: true )
				formatted_delta = metric.unit.convert_from_base( delta.abs, show_units: true )
			else
				formatted_target = metric.active_target.value
				formatted_current = current
				formatted_delta = delta.abs
			end

			direction = delta > 0 ? 'over' : 'under'

			if metric.active_target.target_type == 'current_value'
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

	def log_ate_food_observation
		unless user.present?
			call_intent( :login )
			return
		end

		notes = nil
		params[:quantity] ||= 1

		if params[:food].present?
			begin
				notes = "#{params[:quantity]} #{params[:measure]} of #{params[:food]}" if params[:measure].present?
				notes = "#{params[:portion]} portion of #{params[:food]}" if params[:portion].present?
				notes ||= "#{params[:quantity]} #{params[:food]}"

				# puts "query: #{query}"
				results = NutritionService.new.nutrition_information( query: notes, max: 4 )
				# puts "results #{JSON.pretty_generate results}"

				calories = results[:average_nutrion_facts]['calories']
				calories = calories * params[:portion].to_i if params[:portion].present? && calories.present?

			rescue Exception => e
				NewRelic::Agent.notice_error(e)
				logger.error "log_eaten_observation error"
				logger.error e
				puts e.backtrace

			end

		end

		if results.nil? || results[:results].blank?
			add_speech( system_message = "Sorry, I am unable to find information about #{params[:food]}.")
			return
		end

		if params[:portion].present?
			add_speech( system_message = "Logging that you ate #{params[:portion]} portion of #{params[:food]}.#{calories.present? ? " Approximately #{calories} calories." : ""}")
		elsif params[:quantity].present? && params[:measure].blank?
			add_speech( system_message = "Logging that you ate #{params[:quantity]} #{params[:food]}.#{calories.present? ? " Approximately #{calories} calories." : ""}")
		elsif params[:measure].present?
			add_speech( system_message = "Logging that you ate #{params[:quantity]} #{params[:measure]} of #{params[:food]}.#{calories.present? ? " Approximately #{calories} calories." : ""}.")
		else
			add_speech( system_message = "Sorry, I don't understand.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', system_notes: system_message )
			return
		end

		unit = 'cal'
		metric = get_user_metric( user, unit, unit, true )
		user_unit = Unit.where( metric_id: metric.id, user_id: user.id ).find_by_alias( unit ) || Unit.system.find_by_alias( unit ) || metric.unit
		observation = Observation.create( user: user, observed: metric, value: calories, unit: user_unit, notes: notes )

		results[:average_nutrion_facts].each do |unit, value|
			unless unit.include? 'calories'
				metric = get_user_metric( user, unit, 'g', true )
				user_unit = Unit.where( metric_id: metric.id, user_id: user.id ).find_by_alias( unit ) || Unit.system.find_by_alias( unit ) || metric.unit
				child_observation = Observation.create( user: user, parent: observation, observed: metric, value: value, unit: user_unit, notes: notes )
			end
		end

		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: system_message )

	end

	def log_ate_observation

		unless user.present?
			call_intent( :login )
			return
		end

		if params[:value].blank?
			add_ask( "I'm sorry, I didn't understand that.  You must supply a value in order to log it.  For example \"I ate one hundred calories\" or \"I ate 12 grams of sugar\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply a unit or action with your value in order to log it." )
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'missing value', action: 'reported', system_notes: "Spoke: 'You must supply a value in order to log it.'" )
			return
		end

		# have to double-scan action param cause action a greedy matcher
		if params[:action].present?
			params[:notes] = params[:action].slice!( Regexp.new(ObservationBotService.slots[:ExplicitNotes][:regex].first) ) if params[:action].match( Regexp.new(ObservationBotService.slots[:ExplicitNotes][:regex].first) )
			params[:time_period] = params[:action].slice!( Regexp.new(ObservationBotService.slots[:TimePeriod][:regex].first) ) if params[:action].match( Regexp.new(ObservationBotService.slots[:TimePeriod][:regex].first) )
			params[:action].strip!
		end

		notes = params[:notes].gsub( /note (that)?/i, '' ).strip if params[:notes].present?

		params[:value] = 1.0 if params[:value].match( /a\s+|an\s+/ )

		# trim the unit
		unit = params[:unit].chomp( '.' ).singularize if params[:unit].present?

		action = params[:action].gsub( /(log|record|to |my | todays | is| are| was| = |i | for)/i, '' ).strip if params[:action].present?

		action ||= unit

		action ||= 'cal'

		# fetch the metric
		if metric = get_user_metric( user, action, unit, true )

			user_unit = Unit.where( metric_id: metric.id, user_id: user.id ).find_by_alias( unit ) || Unit.system.find_by_alias( unit ) || metric.unit

			if user_unit.present?
				val = params[:value].to_f * user_unit.conversion_factor
			else
				val = params[:value].to_f
			end

			recorded_at = set_recorded_at( params[:time_period] )

			observation = user.observations.create( observed: metric, value: val, unit: user_unit, recorded_at: recorded_at, notes: notes, content: @raw_input )
			add_speech( observation.to_s( user ) )
		else
			add_ask( "I'm sorry, I didn't understand that.  You must supply a unit or action with your value in order to log it.  For example \"I ate one hundred calories\" or \"I ate 16 grams of sugar\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply a unit or action with your value in order to log it.", deligate_if_possible: true )
			return
		end

		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: "Logged #{observation.display_value( show_units: true )} for #{observation.observed.try(:title) || params[:action]}." )

	end


	def log_burned_observation

		unless user.present?
			call_intent( :login )
			return
		end

		if params[:value].blank?
			add_ask( "I'm sorry, I didn't understand that.  You must supply a value in order to log it.  For example \"I burned one hundred calories\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply a value in order to log it." )
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'missing value', action: 'reported', system_notes: "Spoke: 'You must supply a value in order to log it.'" )
			return
		end

		# @todo parse notes
		notes = params[:notes].gsub( /note (that)?/i, '' ).strip if params[:notes].present?

		val = params[:value].to_f
		val = -val if val > 0

		metric = get_user_metric( user, 'burned', 'cal', true )

		recorded_at = set_recorded_at( params[:time_period] )

		observation = user.observations.create( observed: metric, value: val, recorded_at: recorded_at, content: @raw_input, notes: notes )
		add_speech( observation.to_s( user ) )

		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: "Logged #{observation.display_value( show_units: true )} for #{observation.observed.try(:title) || params[:action]}." )

	end


	def log_drink_observation
		unless user.present?
			call_intent( :login )
			return
		end

		if params[:value].blank? || params[:action].blank?
			add_ask( "I'm sorry, I didn't understand that.  You must supply a value or metric in order to log it.  For example \"I drank one cup of orange juice\" or \"I drank 1 beer\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply a unit or action with your value in order to log it." )
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'missing value or metric', action: 'reported', system_notes: "Spoke: 'You must supply a value or metric in order to log it.'" )
			return
		end

		# have to double-scan action param cause action a greedy matcher
		params[:notes] = params[:action].slice!( Regexp.new(ObservationBotService.slots[:ExplicitNotes][:regex].first) ) if params[:action].match( Regexp.new(ObservationBotService.slots[:ExplicitNotes][:regex].first) )
		params[:time_period] = params[:action].slice!( Regexp.new(ObservationBotService.slots[:TimePeriod][:regex].first) ) if params[:action].match( Regexp.new(ObservationBotService.slots[:TimePeriod][:regex].first) )
		params[:action].strip!

		notes = params[:notes].gsub( /note (that)?/i, '' ).strip if params[:notes].present?

		user_unit = params[:unit]

		params[:value] = 1.0 if params[:value].match( /a|an/ )


		# invocations like 'a cup of milk' leave value params nil
		# we';ll assume one unless given a number like
		# 3 pints of beer
		params[:value] ||= 1

		# take out leading "a " or "an " so "a cup" becomes "cup"
		user_unit.gsub!( /(\Aa.*\s)/i, '' )


		if user_unit.singularize.scan( /ounce|oz/ ).present?
			user_unit = 'fl oz'
		end

		# fetch the metric
		metric = get_user_metric( user, params[:action], user_unit, true )

		unit = Unit.where( metric_id: metric.id, user_id: user.id ).find_by_alias( user_unit ) || Unit.system.find_by_alias( user_unit ) || metric.unit

		val = params[:value].to_f * unit.conversion_factor

		recorded_at = set_recorded_at( params[:time_period] )

		observation = user.observations.create( observed: metric, value: val, unit: unit, recorded_at: recorded_at, content: @raw_input, notes: notes )

		add_speech( observation.to_s( user ) )
		user.user_inputs.create( content: raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: "Logged #{observation.display_value( show_units: true )} for #{observation.observed.title}." )
	end


	def log_journal_observation
		unless user.present?
			call_intent( :login )
			return
		end

		if params[:notes].present?
			notes = params[:notes].gsub( /note (that)?/i, '' ).strip
			observation = user.observations.create( notes: notes, content: @raw_input )
			add_speech( "I recorded your journal entry." )
			user.user_inputs.create( content: @raw_input, result_obj: observation, action: 'created', source: options[:source], result_status: 'success', system_notes: "Spoke: 'I recorded your journal entry.'" )
		end
	end

	def log_start_observation
		unless user.present?
			call_intent( :login )
			return
		end

		if params[:action].blank?
			add_ask( "I'm sorry, I didn't understand that.  You must supply a metric in order to start a timer.  For example \"start jogging timer\" or \"start bike ride\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply an action in order to start a timer.", deligate_if_possible: true )
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'missing metric', action: 'reported', system_notes: "Spoke: 'You must supply a metric in order to log it.'" )
			return
		end

		# @todo parse notes

		notes = params[:notes].gsub( /note (that)?/i, '' ).strip if params[:notes].present?

		params[:action] = params[:action].gsub( /timer/, '' )

		metric = get_user_metric( user, params[:action], 's', true )

		observation = Observation.create( user: user, observed: metric, started_at: Time.zone.now, notes: notes, content: @raw_imput )
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
			add_ask( "I'm sorry, I didn't understand that.  You must supply a metric in order to stop a timer.  For example \"stop jogging timer\" or \"stop bike ride\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply an action in order to stop a timer.", deligate_if_possible: true )
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'missing metric', action: 'reported', system_notes: "Spoke: 'You must supply a metric in order to stop a timer.'" )
			return
		end

		notes = params[:notes].gsub( /note (that)?/i, '' ).strip if params[:notes].present?
		sys_notes = ''

		metric = get_user_metric( user, params[:action], 's' )

		if metric.nil?
			default_metric ||= Metric.where( user_id: nil ).find_by_alias( params[:action].downcase )
			action = default_metric.try( :title ) || params[:action]
			add_speech("Sorry, you haven't recorded anything for #{action} yet.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, you haven't recorded anything for #{action} yet.'" )
			return
		end

		observation = user.observations.of( metric ).where( value: nil ).where( 'started_at is not null' ).order( started_at: :desc ).first

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
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'missing metric', action: 'reported', system_notes: "Spoke: 'You must supply a metric in order to set a target for it.'" )
			return
		end

		metric = get_user_metric( user, params[:action], params[:unit], true )

		system_metric = Metric.where( user_id: nil ).find_by_alias( params[:action].singularize.downcase )
		system_metric ||= Metric.where( user_id: nil ).find_by_alias( params[:unit] ).try( :singularize ).try( :downcase )

		system_target = system_metric.targets.where( user_id: nil ).first

		value = params[:value] || system_target.value


		direction = params[:target_direction].try( :downcase )
		if direction.present?
			direction.gsub!( /\s+/, '_' )
			direction = 'at_least' if direction.match( /min/ )
			direction = 'at_most' if direction .match( /max/ )
		end
		direction ||= system_target.direction

		period = params[:target_period]
		if period.present?
			period.gsub!( /\s+/, '_' )
			period = 'hour' if period.match( /hour/ )
			period = 'day' if period.match( /day/ )
			period = 'day' if period.match( /daily/ )
			period = 'week' if period.match( /week/ )
			period = 'month' if period.match( /month/ )
			period = 'year' if period.match( /year/ )
		else
			period = system_target.period
		end

		type = params[:target_type]
		if type.present?
			type = 'sum_value' if type.match( /total/ )
			type = 'avg_value' if type.match( /average|avg/ )
			type = 'count' if type.match( /check|observation|count/ )
		end

		# unit param is a bit greedy.... so target_type will fall to unit
		# if explicit unit is missing
		unit_str = params[:unit].singularize.downcase if params[:unit].present?

		if unit_str.present?
			if unit_str.match( /check|observation|count|times/ )
				type = 'count'
				unit_str = ''
			elsif unit_str.match( /total/ )
				type = 'sum_value'
				unit_str = ''
			elsif unit_str.match( /average|avg/ )
				type = 'avg_value'
				unit_str = ''
			end
		end

		type ||= system_target.target_type

		if unit_str.present?
			unit = Unit.where( metric_id: metric.id, user_id: user.id ).find_by_alias( unit_str ) || Unit.system.find_by_alias( unit_str )
		end
		unit ||= metric.unit

		target = metric.targets.where( user: user ).last || metric.targets.new( user: user )

		target.unit = unit
		target.direction = direction
		target.period = period
		target.target_type = type

		unless type == 'count'
			target.value = metric.unit.convert_to_base( value )
		else
			target.value = value
		end

		target.save

		disp_value = target.display_value

		response = "I set a target of #{Target.directions[target.direction]} #{disp_value} #{Target.periods[target.period]} for #{metric.title}."
		add_speech( response )

		user.user_inputs.create( content: raw_input, result_obj: metric, action: 'updated', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{response}'" )

	end


	def quick_report
		unless user.present?
			call_intent( :login )
			return
		end

		if params[:action].match( /(calories).*(burn)/i )
			params[:action] = 'calories burned'
		end
		if params[:action].match( /eat/i )
			params[:action] = 'calories'
		end

		# deal with greedy-match action param
		# e.g. 'calories did I eat' or 'beer did i drink' or 'minutes did i work out'

		# first, strip I
		cleaned_action = params[:action].gsub( /\s+i\s+/i, ' ' )

		# next, strip verbs & ' of '
		cleaned_action.gsub!( /\s+do\s+|\s+did\s+|were|\s+of\s+/i, ' ' )

		# and, strip trailing
		cleaned_action.gsub!( /\s+do\z|have|\s+for\z|\s+done/i, ' ' )

		cleaned_action.try( :strip! )

		# ok, lets check for units
		if cleaned_action.match( /\s+/ )
			unit_str = cleaned_action.split( /\s+/ )[0]
			requested_unit = Unit.find_by_alias( unit_str.strip.downcase.singularize )
			cleaned_action.gsub!( unit_str, '' ) if requested_unit.present?
		end

		metric = get_user_metric( user, cleaned_action.strip.parameterize, nil, false )

		if metric.nil?
			cleaned_action.strip.split( /\s+/ ).each do |str|
				metric = get_user_metric( user, str.strip, nil, false )
				break if metric.present?
			end
		end

		if metric.nil?
			default_metric =  Metric.where( user_id: nil ).find_by_alias( cleaned_action.strip.downcase.singularize )
			cleaned_action.split( /\s+/ ).each do |str|
				default_metric = Metric.where( user_id: nil ).find_by_alias( str.strip.downcase.singularize )
				break if default_metric.present?
			end

			action = default_metric.try( :title ) || params[:action]
			add_speech("Sorry, you haven't recorded anything for #{action} yet.")

			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, you haven't recorded anything for #{action} yet.'" )

			return
		end

		period = params[:report_period]

		if period.present?
			period_value = period.scan( /\d+/ ).first
			if period_value.present?
				period_unit = period.scan( /hour|day|week|month|year/ ).first
			end
		end

		if period_value.present?
			if period.scan( /ago/ ).present?
				start_date = eval( "(Time.zone.now - #{period_value}.#{period_unit}).beginning_of_#{period_unit}" )
				end_date = eval( "(Time.zone.now - #{period_value}.#{period_unit}).end_of_#{period_unit}" )
			else # in the last/past x days.... look back x days & ends now
				start_date =  eval "Time.zone.now - #{period_value}.#{period_unit}"
				end_date = Time.zone.now
			end
		elsif period == 'yesterday' || period == 'last night'
			start_date = ( Time.zone.now - 1.day ).beginning_of_day
			end_date = ( Time.zone.now - 1.day ).end_of_day

		elsif period == 'last week'
			start_date = ( Time.zone.now - 1.week ).beginning_of_week
			end_date = ( Time.zone.now - 1.week ).end_of_week

		elsif period == 'last month'
			start_date = ( Time.zone.now - 1.month ).beginning_of_month
			end_date = ( Time.zone.now - 1.month ).end_of_month

		elsif period == 'this week'
			start_date = ( Time.zone.now ).beginning_of_week
			end_date = ( Time.zone.now ).end_of_week

		elsif period == 'this month'
			start_date = ( Time.zone.now ).beginning_of_month
			end_date = ( Time.zone.now ).end_of_month

		elsif period == 'this year'
			start_date = ( Time.zone.now ).beginning_of_year
			end_date = ( Time.zone.now ).end_of_year
		end

		# default to today
		period ||= 'today'
		start_date ||= Time.zone.now.beginning_of_day
		end_date ||= Time.zone.now.end_of_day

		range = start_date..end_date

		if user.observations.for( metric ).where( recorded_at: range ).count < 1
			add_speech("Sorry, there are no observations for #{metric.title} #{period}.")
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'not found', action: 'reported', system_notes: "Spoke: 'Sorry, there are no observations for #{metric.title} #{period}.'" )
			return
		end

		# TODO -- add requested_unit so can report miles run vs time run, etc...
		same_type_unit_ids = Unit.where( unit_type: Unit.unit_types[metric.unit.unit_type] ).pluck( :id )

		if metric.default_value_type == 'max_value'
			value = user.observations.for( metric ).where( unit_id: same_type_unit_ids ).where( recorded_at: range ).maximum( :value )
		elsif metric.default_value_type == 'min_value'
			value = user.observations.for( metric ).where( unit_id: same_type_unit_ids ).where( recorded_at: range ).minimum( :value )
		elsif metric.default_value_type == 'avg_value'
			value = user.observations.for( metric ).where( unit_id: same_type_unit_ids ).where( recorded_at: range ).average( :value )
		elsif metric.default_value_type == 'current_value'
			value = user.observations.for( metric ).where( unit_id: same_type_unit_ids ).where( recorded_at: range ).order( recorded_at: :desc ).first.value
		elsif metric.default_value_type == 'count'
			value = user.observations.for( metric ).where( recorded_at: range ).count
		else # sum_value -- aggregate
			value = user.observations.for( metric ).where( unit_id: same_type_unit_ids ).where( recorded_at: range ).sum( :value )
		end

		if not( metric.default_value_type == 'count' )
			formatted_value = metric.unit.convert_from_base( value )
		else
			formatted_value = "#{value} observations"
		end

		verb = params[:verb]
		if verb.blank? || verb.to_s.match( /did i|do i/i )
			if period.present? && not( period.match( /today|this/i ) )
				if params[:action].singularize == params[:action] && params[:action].pluralize != params[:action]
					verb = 'was'
				else
					verb = 'were'
				end
			else
				if params[:action].singularize == params[:action] && params[:action].pluralize != params[:action]
					verb = 'is'
				else
					verb = 'are'
				end
			end
		end

		# let's add a special case for calories
		if metric.is_calories?
			value_in = user.observations.for( metric ).where( 'value > 0' ).where( unit_id: metric.unit_id ).where( recorded_at: range ).sum( :value )
			value_out = user.observations.for( metric ).where( 'value < 0' ).where( unit_id: metric.unit_id ).where( recorded_at: range ).sum( :value ).abs
			value_net = value_in - value_out
			response = "You've eaten #{value_in} calories and you burned #{value_out}. Your net calories #{verb} #{value_net} #{period}. (#{start_date.to_s( :short )}-#{end_date.to_s( :short )})"
		else
			response = "Your #{metric.title} #{verb} #{formatted_value} #{period}. (#{start_date.to_s( :short ) }-#{end_date.to_s( :short )})"
		end

		add_speech( response )

		user.user_inputs.create( content: raw_input, action: 'reported', source: options[:source], result_status: 'success', system_notes: "Spoke: '#{response}'." )

	end


	def log_metric_observation
		unless user.present?
			call_intent( :login )
			return
		end

		if params[:action].blank?
			add_ask( "I'm sorry, I didn't understand that.  I don't know what to log. You must supply a metric with your value in order to log it.  For example \"log one hundred calories\" or \"my weight is one hundred sixty\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply a unit or action with your value in order to log it.", deligate_if_possible: true )
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'missing metric', action: 'reported', system_notes: "Spoke: 'You must supply a metric in order to log it.'" )
			return

		elsif params[:duration].blank? && params[:value].blank? && params[:unit].blank?
			add_ask( "I'm sorry, I didn't understand that.  You must supply a unit or value with your metric in order to log it.  For example \"log one hundred calories\" or \"my weight is one hundred sixty\".  Now, give it another try.", reprompt_text: "I still didn't understand that.  You must supply a unit or action with your value in order to log it.", deligate_if_possible: true )
			user.user_inputs.create( content: raw_input, source: options[:source], result_status: 'missing value', action: 'reported', system_notes: "Spoke: 'You must supply a value in order to log it.'" )
			return
		end


		# have to double-scan action param cause action a greedy matcher
		params[:notes] = params[:action].slice!( Regexp.new(ObservationBotService.slots[:ExplicitNotes][:regex].first) ) if params[:action].match( Regexp.new(ObservationBotService.slots[:ExplicitNotes][:regex].first) )
		params[:time_period] = params[:action].slice!( Regexp.new(ObservationBotService.slots[:TimePeriod][:regex].first) ) if params[:action].match( Regexp.new(ObservationBotService.slots[:TimePeriod][:regex].first) )
		params[:action].strip!

		# @todo parse notes
		notes = params[:notes].gsub( /note (that)?/i, '' ).strip if params[:notes].present?
		sys_notes = ''

		# trim the unit
		unit = params[:unit].chomp( '.' ).singularize if params[:unit].present?
		unit = 's' if params[:value].match( ':' ) if params[:value].present?

		action = params[:action].gsub( /(log|record|to |my | todays | is| are| was| = |i | for)/i, '' ).strip if params[:action].present?

		params[:value] = 1.0 if params[:value].match( /a|an/ ) if params[:value].present?

		# fetch the metric
		if metric = get_user_metric( user, params[:action], unit, true )

			if metric.unit.volume? && unit.singularize.scan( /ounce|oz/ ).present?
				unit = 'fl oz'
			end

			if params[:duration].present?
				val = ChronicDuration.parse( params[:duration] )
				user_unit = Unit.system.find_by_alias( 's' )
			elsif params[:value].match( ':' )
				val = ChronicDuration.parse( params[:value] )
				user_unit = Unit.system.find_by_alias( 's' )
			else
				user_unit = Unit.where( metric_id: metric.id, user_id: user.id ).find_by_alias( unit ) || Unit.system.find_by_alias( unit ) || metric.unit
				if user_unit.present?
					val = user_unit.convert_to_base( params[:value] )
				else
					val = params[:value].to_f
				end
			end

			recorded_at = set_recorded_at( params[:time_period] )

			observation = user.observations.new( observed: metric, value: val, unit: user_unit, recorded_at: recorded_at, notes: notes, content: @raw_input )

			observation.save
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
				action = action.gsub( /(\Alog|\Arecord|\Ai did|\Adid|to |my | todays | is| are| was| = |i | for|timer|at|around|about|almost|near|close)/i, '' ).strip

				# clean up unit
				# unit ||= 'nada'
				unit = unit.downcase.singularize if unit.present?

				# first, check the user's existing assigned metrics. Return that if exists...
				if user.metrics.find_by_alias( action.downcase )
					return user.metrics.find_by_alias( action.downcase )
				end

				# also check the user's existing assigned metrics based on unit that if exists...
				if unit.present? && user.metrics.find_by_alias( unit )
					return user.metrics.find_by_alias( unit )
				end

				# if we didn't find it in the user's assigned metric list, and create option is invoked...
				if create
					# check the system default metrics
					system_metric = Metric.where( user_id: nil ).find_by_alias( action.downcase )
					system_metric ||= Metric.where( user_id: nil ).find_by_alias( unit )

					if system_metric.present?
						# assign with default display units based on the user's preference
						observed_metric ||= system_metric.dup
						observed_metric.user = user

						if system_metric.unit.volume? && unit.singularize.scan( /ounce|oz/ ).present?
							unit = 'fl oz'
						end

						# convert unit user gave us to base correct unit
						if users_unit = Unit.system.find_by_alias( unit )
							observed_metric.unit = users_unit
						elsif unit.present?
							# create a custom unit... not sure we really want to do this?
							observed_metric.unit = Unit.create name: unit, user_id: user.id, aliases: [ unit.pluralize ], unit_type: observed_metric.try( :unit ).try( :unit_type )
						else # unit.blank?
							observed_metric.unit ||= Unit.nada.first
						end

						if user.use_imperial_units?
							# didn't get a unit from the user... translate to their preference
							# by default, system metric units are metric
							observed_metric.unit = observed_metric.unit.imperial_correlate || observed_metric.unit
						end

						observed_metric.save

						observed_metric.unit.update( metric_id: observed_metric.id ) if observed_metric.unit.user_id.present?

						return observed_metric
					else
						# gotta make a new metric from scratch
						observed_metric ||= Metric.new( title: action )

						if users_unit = Unit.find_by_alias( unit )
							observed_metric.unit = users_unit
						elsif unit.present?
							# create a custom unit... not sure we really want to do this?
							observed_metric.unit = Unit.create name: unit, user_id: user.id, aliases: [ unit.pluralize ], unit_type: observed_metric.try( :unit ).try( :unit_type )
						else
							observed_metric.unit ||= Unit.nada.first
						end

						observed_metric.user = user
						if observed_metric.save
							observed_metric.unit.update( metric_id: observed_metric.id ) if observed_metric.unit.user_id.present?
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

		def set_recorded_at( str )
			return Time.zone.now if str.nil? || str.blank?

			if str.scan( /ago/ ).present?
				str.gsub!( /ago/, '' ).strip
				value = str.slice!( /\d+\s+/ ).strip
				period = str

				return date = eval( "(Time.zone.now - #{value}.#{period})" )
			end

			if str.scan( 'yesterday' ).present? || str == 'last night'
				return Time.zone.now - 1.day
			end

			if str == 'last week'
				return Time.zone.now - 1.week
			end

			if str == 'last month'
				return Time.zone.now - 1.month
			end

			# default to now if we haven't caught anything
			return Time.zone.now

		end

end
