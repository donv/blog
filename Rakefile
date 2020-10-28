# frozen_string_literal: true

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Blog'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path('test/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'

load 'rails/tasks/statistics.rake'

require 'bundler/gem_tasks'

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task default: :test

if Rails.env.development? || Rails.env.test?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
  # require 'rubycritic/rake_task'
  # RubyCritic::RakeTask.new

  namespace :test do
    desc 'Run Rubocop and all tests'
    task full: %i[rubocop:auto_correct test]
  end
end

task 'db:schema:dump' => :environment do
  filename = 'db/schema.rb'
  sh "rubocop --auto-correct-all #{filename} > /dev/null"
  schema = File.read(filename)
               .gsub(', id: :serial', '')
               .gsub(/, id: :integer, default: -> { "nextval\('instructions_id_seq'::regclass\)" }/, '')
  File.write(filename, schema)
end
