source 'https://rubygems.org'

## Base
gem 'rails',                    '~> 4.0.0'
gem 'sass-rails',               '~> 4.0.0'
gem 'coffee-rails',             '~> 4.0.0'
gem 'jquery-rails',             '~> 2.2.1'
gem 'uglifier',                 '~> 2.2.1'

## Domain layer
gem 'mongoid',                  github: 'mongoid/mongoid'
gem 'geocoder',                 '~> 1.1.8'
gem 'nokogiri',                 '~> 1.5.6'

## View stuff
gem 'active_model_serializers', '~> 0.8.1'
gem 'compass-rails',            '~> 2.0.alpha.0'
gem 'haml-rails',               '~> 0.3.5'
gem 'bourbon'
gem 'neat'
gem 'underscore-rails'

## I18n
gem 'http_accept_language',     github: 'sespindola/http_accept_language'
gem 'rails-i18n',               '~> 0.6.4'

## Deployment
gem 'production_chain',         github: 'novelys/production_chain'
gem 'capistranovelys',          git: 'git@github.com:novelys/capistranovelys.git'
gem 'whenever',                 '~> 0.8.2'

group :development do
  gem 'thin'
  gem 'pry'
  gem 'pry-nav'
  gem 'debugger'
  gem 'delorean'
  gem 'pry-rails'
  gem 'quiet_assets'
end

group :staging, :production do
  gem 'unicorn'
end
