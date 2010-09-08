require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rcov/rcovtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "secure_carrot"
    s.email = "sriram.varahan@gmail.com"
    s.homepage = "http://github.com/sriram/carrot"
    s.description = "A fork of carrot with added features for encrypting and decrypting messages."
    s.summary = "A synchronous version of the ruby amqp client with added security features"
    s.authors = ["Sriram Varahan"]
    s.add_runtime_dependency 'encrypted_strings'
    s.files = FileList["[A-Z]*", "{bin,generators,lib,test}/**/*"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'secure_carrot'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rcov::RcovTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :default => :test
