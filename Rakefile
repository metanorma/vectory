# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :inkscape_version do
  system('inkscape --version')
end

task default: :spec

# require "rubocop/rake_task"

# RuboCop::RakeTask.new

# task default: %i[spec rubocop]
