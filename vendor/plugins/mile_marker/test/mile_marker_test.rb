require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))

class MileMarkerTest < Test::Unit::TestCase
  include Thoughtbot::MileMarkerHelper

  def test_mile_helper_should_return_nothing_if_no_enabled
    Thoughtbot::MileMarker.environments = ['development']
    ENV['RAILS_ENV']="test_environment"
    output = mile("Milestone 1")
    assert_nil output
  end

  def test_mile_helper_should_include_detail_when_supplied_detail
    Thoughtbot::MileMarker.environments = ['development']
    ENV['RAILS_ENV']="development"
    output = mile("Milestone 1")
    assert_equal "mile=\"Milestone 1\"", output
  end
  
  def test_mile_helper_should_include_add_milestone_when_supplied_integer
    Thoughtbot::MileMarker.environments = ['development']
    ENV['RAILS_ENV']="development"
    output = mile(1)
    assert_equal "mile=\"Milestone 1\"", output
  end
    
  def test_mile_helper_should_include_no_detail_when_supplied_no_detail
    Thoughtbot::MileMarker.environments = ['development']
    ENV['RAILS_ENV']="development"
    output = mile
    assert_equal "mile=\"\"", output
  end
  
  def test_calling_enabled_should_add_current_environment_to_environments
    Thoughtbot::MileMarker.environments = []
    ENV['RAILS_ENV']="test_environment"
    Thoughtbot::MileMarker.enable
    assert Thoughtbot::MileMarker.environments.include?(ENV['RAILS_ENV'])
  end
  
  def test_calling_disabled_should_remove_current_environment_from_environments
    Thoughtbot::MileMarker.environments = []
    ENV['RAILS_ENV']="test_environment"
    Thoughtbot::MileMarker.enable
    assert Thoughtbot::MileMarker.environments.include?(ENV['RAILS_ENV'])
    Thoughtbot::MileMarker.disable
    assert !Thoughtbot::MileMarker.environments.include?(ENV['RAILS_ENV'])
  end
  
  def test_initialize_mile_should_return_nothing_if_not_enabled
    ENV['RAILS_ENV']="test_environment"
    output = initialize_mile_marker
    assert_nil output
  end

  def test_initialize_mile_should_return_javascript_if_enabled
    Thoughtbot::MileMarker.environments = ['development']
    ENV['RAILS_ENV']="development"
    output = initialize_mile_marker
    assert_match /function init_miles/, output
  end
  
  def test_javascript_should_be_added_to_head_if_enabled
    Thoughtbot::MileMarker.environments = ['development']
    ENV['RAILS_ENV']="development"
    response.body = "<head></head>"
    add_initialize_mile_marker
    assert_match /script/, response.body
  end
  
  def test_z_index_and_other_options_in_css_set_as_specified_in_options
    Thoughtbot::MileMarker.environments = ['development']
    Thoughtbot::MileMarker.options[:z_index] = "1234"
    Thoughtbot::MileMarker.options[:background_color] = "purple"
    ENV['RAILS_ENV']="development"
    response.body = "<head></head>"
    add_initialize_mile_marker
    assert_match /script/, response.body
    assert_match /z-index: 1234/, response.body
    assert_match /background-color: purple/, response.body
  end
end