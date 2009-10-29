require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/invocation'

class InvocationTest < Test::Unit::TestCase

  include Mocha

  def test_has_mock_method_name_and_args
    mock   = 'a mock'
    method = :call_me
    args   = [1, 2]
    invocation = Invocation.new(mock, method, args)
    assert_equal mock, invocation.mock
    assert_equal method, invocation.method_name
    assert_equal args, invocation.arguments
  end
end
