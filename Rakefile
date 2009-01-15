rspec_base = File.expand_path(File.dirname(__FILE__) + '/../rspec/lib')
$LOAD_PATH.unshift(rspec_base) if File.exist?(rspec_base)

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec/rake/spectask'

desc 'Default: runs specs.'
task :default => :spec

desc 'Run all specs in spec directory.'
Spec::Rake::SpecTask.new(:spec) do |task|
  task.libs = ['lib', 'spec']
  task.spec_files = FileList['spec/**/*_spec.rb']
end