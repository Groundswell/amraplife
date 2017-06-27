class NutritionService

	def nutrition_information( args = {} )


		if args[:query].present?
			args[:min] ||= 0
			args[:max] ||= 4

			search_params = {
				results: "#{args[:min]}:#{args[:max]}",
				# cal_min=0
				# cal_max=50000
				fields: '*',
				appId: ENV['NUTRITIONX_API_ID'],
				appKey: ENV['NUTRITIONX_API_KEY'],
			}

			api_endpoint = "https://api.nutritionix.com/v1_1/search/#{URI.encode(args[:query])}"

			json_string_response = RestClient.get( api_endpoint, { accept: :json, params: search_params } )
			response = JSON.parse( json_string_response, :symbolize_names => true )

			results = response[:hits].collect do |row|

				nutrition_facts = {}
				serving_measures = []

				servings_per_container = row[:fields].delete(:nf_servings_per_container)
				serving_qty = row[:fields].delete(:nf_serving_size_qty)
				serving_unit = row[:fields].delete(:nf_serving_size_unit)
				serving_weight_grams = row[:fields].delete(:nf_serving_weight_grams)

				row[:fields].each do |key,value|
					if key.to_s.start_with?('nf_')
						nutrition_facts[key.to_s[3..-1].to_sym] = value
					end
				end

				{
					_score: row[:_score],
					type: :food,
					name: "#{row[:fields][:brand_name]} #{row[:fields][:item_name]}".strip,
					serving_qty: serving_qty,
					serving_unit: serving_unit,
					serving_weight_grams: serving_weight_grams,
					servings_per_container: servings_per_container,
					nutrion_facts: nutrition_facts,
					serving_measures: serving_measures,
				}
			end

			return {
				total_count: response[:total_hits],
				best_score: response[:max_score],
				average_calories: (results.collect{ |result| result[:nutrion_facts][:calories] }.sum / results.count).round(2),
				results: results
			}

		elsif args[:text].present?

			query_headers = {
				'x-app-id': ENV['NUTRITIONX_API_ID'],
				'x-app-key': ENV['NUTRITIONX_API_KEY'],
				content_type: :json,
				accept: :json
			}

			query_body = {
				query: args[:text],
				timezone: "US/Eastern",
			}

			api_endpoint = 'https://trackapi.nutritionix.com/v2/natural/nutrients'

			json_string_response = RestClient.post( api_endpoint, query_body.to_json, query_headers )
			response = JSON.parse( json_string_response, :symbolize_names => true )



			results = response[:foods].collect do |row|

				nutrition_facts = {}
				serving_measures = []

				row.each do |key,value|
					if key.to_s.start_with?('nf_')
						nutrition_facts[key.to_s[3..-1].to_sym] = value
					end
				end

				row[:alt_measures].sort{|a,b| a[:seq] <=> b[:seq] }.each do |measure|
					serving_measures << {
						weight_grams: measure[:serving_weight],
						unit: measure[:measure],
						seq: measure[:seq],
					}
				end

				{
					type: :food,
					name: row[:food_name],
					serving_qty: row[:serving_qty],
					serving_unit: row[:serving_unit],
					serving_weight_grams: row[:serving_weight_grams],
					servings_per_container: nil,
					nutrion_facts: nutrition_facts,
					serving_measures: serving_measures,
				}
			end


			return {
				total_count: response[:foods].count,
				results: results
			}

		end

	end

end
