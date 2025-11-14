# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"

# Add coverage configuration for CI
if ENV["COVERAGE"] == "true"
  require "simplecov"
  require "codecov"

  SimpleCov.start do
    add_filter "/test/"
    add_filter "/vendor/"
    enable_coverage :branch
    minimum_coverage line: 90, branch: 60
  end

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
    [SimpleCov::Formatter::SimpleFormatter, SimpleCov::Formatter::Codecov]
  )
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

RuboCop::RakeTask.new

desc "Build gem"
task :build_gem do
  sh "gem build pike13.gemspec"
end

desc "Clean build artifacts"
task :clean do
  sh "rm -f pike13-*.gem"
end

task default: %i[test rubocop]
