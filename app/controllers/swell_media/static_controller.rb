module SwellMedia
	class StaticController < ApplicationController

		def about
			set_page_meta( title: 'About Us' )
		end

		def crossfit_terms
		end


		def home
			# the homepage
			@articles = SwellMedia::Article.published.order( publish_at: :desc ).limit( 8 )
			if SwellMedia::Article.published.count > 5
				@trending = SwellMedia::Article.published.order( publish_at: :asc ).limit( SwellMedia::Article.published.count - 5 )
				@trending = @trending[ rand( @trending.length ) ]
			else
				@trending = SwellMedia::Article.published.last
			end

			@recipes = Recipe.published.order( publish_at: :desc ).limit( 10 )
			#@workouts = Workout.published.order( publish_at: :desc ).limit( 10 )

			set_page_meta( title: 'AMRAP Life Home' )

			render layout: 'swell_media/homepage'
		end

	end
end
