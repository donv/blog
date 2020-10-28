# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'blog_engine/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'blog_engine'
  spec.version     = BlogEngine::VERSION
  spec.authors     = ['Uwe Kubosch']
  spec.email       = ['uwe@kubosch.no']
  spec.homepage    = 'https://github.com/donv/blog'
  spec.summary     = 'A simple personal blog'
  spec.description = 'A simple personal blog'
  spec.license     = 'UNLICENSED'
  spec.required_ruby_version = '~>2.7'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'bootsnap'
  spec.add_dependency 'dynamic_form'
  spec.add_dependency 'jbuilder'
  spec.add_dependency 'jquery-rails'
  spec.add_dependency 'mini_magick'
  # spec.add_dependency 'mini_racer'
  spec.add_dependency 'pg'
  spec.add_dependency 'puma'
  spec.add_dependency 'rails', '~> 6.0'
  spec.add_dependency 'RedCloth'
  spec.add_dependency 'sassc-rails'
  spec.add_dependency 'uglifier'

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'listen'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rails'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'web-console'
end
