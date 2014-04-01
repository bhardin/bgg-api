# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'jeweler'
require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'rspec/core/rake_task'

task default: :spec

Jeweler::Tasks.new do |gem|
  gem.name = 'bgg-api'
  gem.homepage = 'http://github.com/bhardin/bgg-api'
  gem.license = 'MIT'
  gem.summary = 'boardgamegeek api gem'
  gem.description = 'A gem to interact with the BGG API'
  gem.email = 'hardin.brett@gmail.com'
  gem.authors = ['Brett Hardin']
end
Jeweler::RubygemsDotOrgTasks.new

RSpec::Core::RakeTask.new(:spec)

task :coverage do
  ENV['COVERAGE'] = 'yes'
  Rake::Task['spec'].execute
end

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bgg-api #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
