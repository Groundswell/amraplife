class FeedController < ApplicationController

	def index

		@title = 'AMRAPLife'
		@description = 'Chock-full of great recipes and health tips sprinkled with inspiration and cool stuff.'
		@source = 'Feedly' if (request.user_agent || '').include?('Feedly/')
		@source = params[:source] if params[:source].present?
		@url = main_app.feed_index_url(source: @source, v: params[:version] || '1.0')

		@articles = SwellMedia::Article.published.order(publish_at: :desc).page(params[:page]).per(100).to_a
		@first_article = @articles.first
		@last_article = @articles.last

		@recipes = Recipe.published.where('publish_at BETWEEN ? AND ?', @last_article.publish_at, @first_article.publish_at).order(publish_at: :desc).limit(100)
		@products = []
		# @products = Product.published.where('publish_at BETWEEN ? AND ?', @last_article.publish_at, @first_article.publish_at).order(publish_at: :desc).limit(100)

		@results = (@articles + @recipes + @products).sort{ |a, b| b.publish_at <=> a.publish_at }
		@results = @results[0..100]

	end

end
