source 'https://rubygems.org'

ruby '2.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.2'
gem 'puma'
gem 'compass-rails'
gem 'coffee-rails'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'oj'

## Domain layer
gem 'mongoid'
gem 'geocoder'
gem 'mongoid-slug'
gem 'redis-rails'

## Scheduling of availability fetching
gem 'clockwork'

## View stuff
gem 'haml-rails'
gem 'active_model_serializers'
gem 'responders'
gem 'jquery-rails'
gem 'underscore-rails'
gem 'bootstrap-sass'
gem 'font-awesome-rails'

## I18n
gem 'http_accept_language'
gem 'rails-i18n'

## Deployment
gem 'rollbar'
gem 'asset_sync'
gem 'sitemap_generator'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'pry-rails'
  gem 'pry-nav'
  gem 'dotenv-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  gem 'rails_12factor'
end
