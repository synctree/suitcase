require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w(-c --fail-fast --format d)
end

task :install_nodoc => [:build] do
  system "gem install pkg/suitcase-#{Suitcase::VERSION}.gem --no-ri --no-rdoc"
end
