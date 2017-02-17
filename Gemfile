ruby '2.3.2'

source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails', '< 6'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'sitemap_generator'

gem 'carrierwave'
gem 'dalli'
gem 'gibbon'
gem 'memcachier'
gem 'newrelic_rpm'
gem 'sendgrid-ruby'


gem 'unicorn'

# dev
# gem 'swell_media', path: '../../engines/swell_media'
# gem 'swell_theme_summarize', path: '../../engines/swell_theme_summarize'

# gem 'swell_ecom', path: '../../engines/swell_ecom'


# prod
gem 'swell_media', git: 'git://github.com/Groundswell/swell_media.git'
gem 'swell_theme_summarize', git: 'git://github.com/Groundswell/swell_theme_summarize.git'

# gem 'swell_ecom', git: 'git://github.com/Groundswell/swell_ecom.git'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
end
