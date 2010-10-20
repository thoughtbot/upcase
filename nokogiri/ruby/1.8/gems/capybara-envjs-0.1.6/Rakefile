# -*- Mode: Ruby -*-

require 'rubygems'

gem 'hoe', '>= 2.5'
require 'hoe'

Hoe.plugin 
Hoe.plugin :debugging, :doofus, :git
Hoe.plugins.delete :rubyforge

Hoe.spec 'capybara-envjs' do
  developer 'Steven Parkes', 'smparkes@smparkes.net'
  self.version = "0.1.6"

  self.readme_file      = 'README.rdoc'
  self.extra_rdoc_files = Dir['*.rdoc']

  self.extra_deps = [
    ['capybara', '>= 0.3.9'],
    ['envjs', '>= 0.3.7']
  ]

  self.extra_dev_deps = [
    ['rack-test', '>= 0.5.4'],
    ['rspec', '>= 1.3.0']
  ]
end
