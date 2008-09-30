require File.dirname(__FILE__) + '<%= directory_slashes %>/../test_helper'

class <%= helper_class_name %>HelperTest < HelperTestCase

  include <%= helper_class_name %>Helper

  #fixtures :users, :articles

  def setup
    super
  end
  
end
