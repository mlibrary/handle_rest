require 'dotenv/tasks'
require "rubocop/rake_task"
require "rspec/core/rake_task"

RuboCop::RakeTask.new(:rubocop)
RSpec::Core::RakeTask.new(:spec)

namespace :rubocop do
  RuboCop::RakeTask.new(:fix) do |t|
    t.options = ["--auto-correct-all"]
  end
end

task ci: %i[rubocop spec]
task default: :ci
