class FeedController < ApplicationController

	def index

		# if params[:format].blank?
		# 	redirect_to feed_index_path( format: :rss )
		# 	return false
		# end


		@title = 'AMRAPLife'
		@description = 'Chock-full of great recipes and health tips sprinkled with inspiration and cool stuff.'
		@source = 'Feedly' if (request.user_agent || '').include?('Feedly/')
		@source = params[:source] if params[:source].present?
		@url = main_app.feed_index_url(source: @source, v: params[:version] || '1.0')

		@articles = SwellMedia::Article.published.order(publish_at: :desc).page(params[:page]).per(100).to_a
		@first_article = @articles.first
		@last_article = @articles.last

		@recipes = Recipe.published.order(publish_at: :desc).limit(100).to_a
		@products = []
		# @products = Product.published.where('publish_at BETWEEN ? AND ?', @last_article.publish_at, @first_article.publish_at).order(publish_at: :desc).limit(100)

		@results = (@articles + @recipes + @products).sort{ |a, b| b.publish_at <=> a.publish_at }
		@results = @results[0..100]

		begin
			render :index
		rescue
			redirect_to feed_index_path( format: :rss )
		end

		
	end

end
