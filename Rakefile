require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rcov/rcovtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |g|
    g.name = 'has_many_translations'
    g.summary = %(Keep a DRY multilingual translation of your ActiveRecord models' textual attributes)
    g.description = %(Keep a DRY multilingual translation of your ActiveRecord models' textual attributes)
    g.email = 'mjording@openogotham.com'
    g.homepage = 'http://github.com/opengotham/has_many_translations'
    g.authors = %w(opengotham)
    g.add_dependency 'activerecord', '>= 2.1.0'
    g.add_development_dependency 'shoulda'
    g.add_development_dependency 'mocha'
    g.add_runtime_dependency 'sishen-rtranslate'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end

Rake::TestTask.new do |t|
  t.libs = %w(test)
  t.pattern = 'test/**/*_test.rb'
end

Rcov::RcovTask.new do |t|
  t.libs = %w(test)
  t.pattern = 'test/**/*_test.rb'
end

task :test => :check_dependencies
task :default => :test

Rake::RDocTask.new do |r|
  version = File.exist?('VERSION') ? File.read('VERSION') : nil
  r.rdoc_dir = 'rdoc'
  r.title = ['has_many_translations', version].compact.join(' ')
  r.options << '--line-numbers' << '--inline-source'
  r.rdoc_files.include('README*')
  r.rdoc_files.include('lib/**/*.rb')
end
