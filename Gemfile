source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'



# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'haml-rails'
gem 'mongoid'
gem 'nokogiri'
gem 'rails-i18n'

gem 'capistrano'
gem 'capistrano-ext'
gem 'whenever'

gem 's3'
gem 'production_chain'

group :development do
  # Debugging
  gem 'pry'
  gem 'pry-nav'
  gem 'debugger'
  gem 'delorean'
  gem 'pry-rails'
end

# Webserver
group :development do  
  gem 'thin'
  gem 'quiet_assets'
  gem 'sextant'
end

group :staging, :production do
  gem 'unicorn'
end

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
