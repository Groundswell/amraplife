SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
		fog_provider: 'AWS',
		:aws_access_key_id      => ENV['AMZN_ASOC_KEY'],       # required
		:aws_secret_access_key  => ENV['AMZN_ASOC_SECRET'],     # required
		fog_directory: ENV['FOG_DIRECTORY']
		)

SitemapGenerator::Sitemap.create_index = :auto
SitemapGenerator::Sitemap.default_host = "http://www.amraplife.com"
SitemapGenerator::Sitemap.public_path = 'tmp/'

SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
	add '/'
	add '/about'
	add '/privacy'
	add '/terms'
	add '/blog'
	#add '/recipes'
	#add '/places'
	#add '/workouts'
	SwellMedia::Media.active.each do |media|
		add media.path, lastmod: media.updated_at
	end
	# Equipment.active.each do |equipment|
	# 	add equipment.path, lastmod: equipment.updated_at
	# end
	# Recipe.active.each do |recipe|
	# 	add recipe.path, lastmod: recipe.updated_at
	# end
	# Movement.active.each do |movement|
	# 	add movement.path, lastmod: movement.updated_at
	# end
	# Workout.active.each do |workout|
	# 	add workout.path, lastmod: workout.updated_at
	# end
end