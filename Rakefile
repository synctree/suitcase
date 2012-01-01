require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :spec

task :spec do
  system "rspec spec/"
end

task :install_nodoc => [:build] do
  system "gem install pkg/suitcase-#{Suitcase::VERSION}.gem --no-ri --no-rdoc"
end
