source 'https://rubygems.org'

gem 'rails', '~>5.2.0'

platform :jruby do
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'rmagick4j', require: 'RMagick'
  gem 'therubyrhino'
end

platform :ruby do
  gem 'pg'
  gem 'mini_magick'
  gem 'mini_racer'
end

# gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap'
# gem 'coffee-rails', '~> 4.1.0'
gem 'dynamic_form'
gem 'jbuilder'
gem 'jquery-rails'
gem 'puma'
gem 'RedCloth'
gem 'sassc-rails'
gem 'uglifier'
gem 'will_paginate'

group :development do
  gem 'web-console'
end

group :development, :test do
  gem 'binding_of_caller', '0.7.3.pre1'
  gem 'byebug', platform: :ruby
end

group :test do
  gem 'minitest-reporters'
  gem 'simplecov'
  gem 'timecop'
end
