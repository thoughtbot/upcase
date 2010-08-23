require "rubygems"
require "spec"
require "rr"

project_root = File.expand_path("#{__FILE__}/../..")
$LOAD_PATH << "#{project_root}/lib"
$LOAD_PATH << "#{project_root}/spec/support/lib"

Spec::Runner.configure do |config|
  config.mock_with RR::Adapters::Rspec
end
