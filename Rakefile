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
  gem.name = 'bgg'
  gem.homepage = 'http://github.com/jemiahlee/bgg'
  gem.license = 'MIT'
  gem.summary = 'object-oriented boardgamegeek api gem'
  gem.description = 'Object-oriented interface for interacting with Boardgamegeek API'
  gem.email = 'jeremiah.lee@gmail.com'
  gem.authors = ['Jeremiah Lee', 'Brett Hardin']
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
  rdoc.title = "bgg #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
