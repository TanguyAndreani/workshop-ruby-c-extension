require 'rubygems'
require 'rake/extensiontask'
require 'bundler/gem_tasks'

Rake::ExtensionTask.new('.') { |ext|
    ext.name = "hello_c"
}

task :default => [:compile]