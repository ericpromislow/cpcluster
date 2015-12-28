require 'rake/testtask'

gemspec = Gem::Specification::load(File.expand_path('../cpcluster.gemspec', __FILE__))

#
# Tests
#
task :default => [:test]

Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
  t.warning = true
end

