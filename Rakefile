require "bundler/gem_tasks"
# require 'suitcase'

task :install_nodoc => [:build] do
  system "gem install pkg/suitcase-#{Suitcase::VERSION}.gem --no-ri --no-rdoc"
end
