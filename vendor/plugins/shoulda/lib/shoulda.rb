require 'shoulda/gem/shoulda'
require 'shoulda/private_helpers'
require 'shoulda/general'
require 'shoulda/active_record_helpers'
require 'shoulda/controller_tests/controller_tests.rb'
require 'yaml'

shoulda_options = {}

possible_config_paths = []
possible_config_paths << File.join(ENV["HOME"], ".shoulda.conf")       if ENV["HOME"]
possible_config_paths << "shoulda.conf"
possible_config_paths << File.join("test", "shoulda.conf")
possible_config_paths << File.join(RAILS_ROOT, "test", "shoulda.conf") if defined?(RAILS_ROOT) 

possible_config_paths.each do |config_file|
  if File.exists? config_file
    shoulda_options = YAML.load_file(config_file).symbolize_keys
    break
  end
end

require 'shoulda/color' if shoulda_options[:color]

module Test # :nodoc: all
  module Unit 
    class TestCase

      include ThoughtBot::Shoulda::General
      include ThoughtBot::Shoulda::Controller

      extend ThoughtBot::Shoulda::ActiveRecord
    end
  end
end

module ActionController #:nodoc: all
  module Integration
    class Session 
      include ThoughtBot::Shoulda::General
    end
  end
end
