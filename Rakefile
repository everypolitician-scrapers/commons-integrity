# frozen_string_literal: true

require 'rake/testtask'
require 'reek/rake/task'
require 'rubocop/rake_task'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.warning = true
  t.verbose = true
  t.test_files = FileList['test/**/*.rb']
end

RuboCop::RakeTask.new
Reek::Rake::Task.new

task default: %w[test rubocop reek]
