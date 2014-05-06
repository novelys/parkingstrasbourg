source 'https://rubygems.org'

ruby '2.1.1'

## Base
gem 'rails',                    '~> 4.1.0'
gem 'sass-rails',               '~> 4.0.3'
gem 'haml-rails',               '~> 0.5.0'
gem 'coffee-rails',             '~> 4.0.0'
gem 'jquery-rails',             '~> 2.2.1'
gem 'uglifier',                 '~> 2.2.1'

## Domain layer
gem 'mongoid',                  github: 'mongoid/mongoid'
gem 'geocoder',                 '~> 1.1.8'
gem 'nokogiri',                 '~> 1.5.6'
gem 'mongoid_slug'

## Scheduling of availability fetching
gem 'resque',           '~> 1.25.2'
gem 'clockwork'

## View stuff
gem 'active_model_serializers', '~> 0.8.1'
gem 'underscore-rails'
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'turbolinks'
gem 'compass-rails'

## I18n
gem 'http_accept_language',     github: 'sespindola/http_accept_language'
gem 'rails-i18n',               '~> 0.6.4'

## Deployment
gem 'airbrake'
gem 'production_chain',         '~> 0.0.10'
gem 'capistranovelys',          '~> 2.0.0'
gem 'whenever',                 '~> 0.8.2'
gem 'asset_sync'
gem 'sitemap_generator'
gem 'dotenv-rails'

group :development do
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'
  gem 'quiet_assets'
  gem 'thin'
  gem 'spring'
end

group :staging, :production do
  gem 'puma'
  gem 'rails_12factor'
end
