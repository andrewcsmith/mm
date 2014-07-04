# -*- ruby -*-

require "rubygems"
require "hoe"

# Hoe.plugin :compiler
# Hoe.plugin :gem_prelude_sucks
# Hoe.plugin :racc
# Hoe.plugin :rcov
Hoe.plugin :flay
Hoe.plugin :flog

Hoe.plugin :travis
Hoe.plugin :inline
Hoe.plugin :minitest
Hoe.plugin :package

hoe = Hoe.spec "mm" do |h|
  developer("Andrew C. Smith", "andrewchristophersmith@gmail.com")
  license "MIT" # this should match the license in the README
  self.readme_file = "README.rdoc"
  require_rubygems_version '>= 1.4'
end

if ENV['CODECLIMATE_REPO_TOKEN']
  hoe.test_prelude = <<CC
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
CC
end

# vim: syntax=ruby
