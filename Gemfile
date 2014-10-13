source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platforms => :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', require: false

# KalibroService
gem 'kalibro_gem', '~> 0.0.2'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', group: :development

# Requests via HTTP
gem "faraday_middleware", "~> 0.9.0"

# Sends a email whenever there is a unexpected exception
gem 'exception_notification', '~> 4.0.1'

group :test do
  # Easier test writing
  gem "shoulda-matchers"

  # Test coverage
  gem 'simplecov', require: false
end

group :development, :test do
  # Test framework
  gem 'rspec-rails', '~> 3.1.0'

  # Fixtures made easy
  gem 'factory_girl_rails', '~> 4.4.1'

  gem 'mocha', '~> 1.1.0'

  # Deployment
  gem 'capistrano', "~>3.2.1", require: false
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm', "~>0.1.0"
end

group :local do
  # Enables the app to handle multiple paralell requests on local environment
  gem 'puma', '~> 2.9.0'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use debugger
# gem 'debugger', group: [:development, :test]
