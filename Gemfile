source 'https://rubygems.org'
ruby '2.5.1'

gem 'pry-rails'
gem 'pg'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# gem 'http'
gem 'puma', '~> 2.13'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

gem 'apipie-rails'

gem 'rollbar'

gem 'bootsnap', '>= 1.1.0', require: false

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :test, :development do
  # gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  # gem 'fakeweb'
  gem 'ffaker'
  # gem 'looksee'
  gem 'pry-remote'
  gem 'rspec-rails'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # gem 'selenium-webdriver'
end

group :production do
  gem 'rails_12factor'
end

