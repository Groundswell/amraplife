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

gem 'alexa_rubykit'
gem 'carrierwave'
gem 'chronic_duration'
gem 'dalli'
gem 'elasticsearch'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'bonsai-elasticsearch-rails'
gem 'gibbon'
gem "google_assistant"
gem 'kaminari'
gem 'memcachier'
gem 'newrelic_rpm'
gem 'numbers_in_words'
gem 'rest-client'
gem 'ruby-measurement' # for parsing amount/unit strings
gem 'sendgrid-ruby'
gem 'statsample' # to muck around with
gem 'unitwise' # for performing actual amount/unit conversion

gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'

gem 'unicorn'

# dev
# gem 'swell_media', path: '../../engines/swell_media'
# gem 'swell_theme_store', path: '../../engines/swell_theme_store'

# gem 'swell_ecom', path: '../../engines/swell_ecom'


# prod
gem 'swell_media', git: 'git://github.com/Groundswell/swell_media.git'
gem 'swell_theme_store', git: 'git://github.com/Groundswell/swell_theme_store.git'

gem 'swell_ecom', git: 'git://github.com/Groundswell/swell_ecom.git'

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
