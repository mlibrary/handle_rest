require "standard/rake"
require "rubocop/rake_task"
require "rspec/core/rake_task"

RuboCop::RakeTask.new(:rubocop)
RSpec::Core::RakeTask.new(:spec)

namespace :rubocop do
  RuboCop::RakeTask.new(:fix) do |t|
    t.options = ["--auto-correct-all"]
  end

  # task standard:fix declared in standard/rake
  task fix: %i[standard:fix]
end

# task standard declared in standard/rake
task rubocop: %i[standard]
task ci: %i[rubocop spec]
task default: :ci
