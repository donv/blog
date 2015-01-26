source 'https://rubygems.org'

gem 'rails', '~>4.2.0'

platform :jruby do
  gem 'activerecord-jdbcpostgresql-adapter', groups: [:development, :test]
  gem 'activerecord-jdbcmysql-adapter', group: :production
  gem 'rmagick4j'
  gem 'therubyrhino'
end

platform :ruby do
  gem 'pg'
  gem 'rmagick'
  gem 'therubyracer'
end

# gem 'bcrypt', '~> 3.1.7'
gem 'coffee-rails', '~> 4.1.0'
gem 'dynamic_form'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'puma'
gem 'RedCloth'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'
gem 'will_paginate'

group :development do
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
end

group :development, :test do
  gem 'binding_of_caller', '0.7.3.pre1'
  gem 'byebug', platform: :ruby
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

group :test do
  gem 'minitest-reporters'
  gem 'timecop'
end
