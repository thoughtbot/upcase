require File.join(File.dirname(__FILE__), "acceptance_test_helper")
require 'mocha'
require 'matcher_helpers'

module SpyTestMethods

  def setup
    setup_acceptance_test
  end
  
  def teardown
    teardown_acceptance_test
  end
  
  def test_should_accept_wildcard_stub_call_without_arguments
    instance = new_instance
    instance.stubs(:to_s)
    instance.to_s
    assert_received(instance, :to_s)
    assert_matcher_accepts have_received(:to_s), instance
  end

  def test_should_accept_wildcard_stub_call_with_arguments
    instance = new_instance
    instance.stubs(:to_s)
    instance.to_s(:argument)
    assert_received(instance, :to_s)
    assert_matcher_accepts have_received(:to_s), instance
  end

  def test_should_not_accept_wildcard_stub_without_call
    instance = new_instance
    instance.stubs(:to_s)
    assert_fails { assert_received(instance, :to_s) }
    assert_fails { assert_matcher_accepts have_received(:to_s), instance }
  end

  def test_should_not_accept_call_without_arguments
    instance = new_instance
    instance.stubs(:to_s)
    instance.to_s
    assert_fails { assert_received(instance, :to_s) {|expect| expect.with(1) } }
    assert_fails { assert_matcher_accepts have_received(:to_s).with(1), instance }
  end

  def test_should_not_accept_call_with_different_arguments
    instance = new_instance
    instance.stubs(:to_s)
    instance.to_s(2)
    assert_fails { assert_received(instance, :to_s) {|expect| expect.with(1) } }
    assert_fails { assert_matcher_accepts have_received(:to_s).with(1), instance }
  end

  def test_should_accept_call_with_correct_arguments
    instance = new_instance
    instance.stubs(:to_s)
    instance.to_s(1)
    assert_received(instance, :to_s) {|expect| expect.with(1) }
    assert_matcher_accepts have_received(:to_s).with(1), instance
  end

  def test_should_accept_call_with_wildcard_arguments
    instance = new_instance
    instance.stubs(:to_s)
    instance.to_s('hello')
    assert_received(instance, :to_s) {|expect| expect.with(is_a(String)) }
    assert_matcher_accepts have_received(:to_s).with(is_a(String)), instance
  end

  def test_should_reject_call_on_different_mock
    instance = new_instance
    other    = new_instance
    instance.stubs(:to_s)
    other.stubs(:to_s)
    other.to_s('hello')
    assert_fails { assert_received(instance, :to_s) {|expect| expect.with(is_a(String)) } }
    assert_fails { assert_matcher_accepts have_received(:to_s).with(is_a(String)), instance }
  end

  def test_should_accept_correct_number_of_calls
    instance = new_instance
    instance.stubs(:to_s)
    2.times { instance.to_s }
    assert_received(instance, :to_s) {|expect| expect.twice }
    assert_matcher_accepts have_received(:to_s).twice, instance
  end

  def test_should_reject_not_enough_calls
    instance = new_instance
    instance.stubs(:to_s)
    instance.to_s
    message = /expected exactly twice/
    assert_fails(message) { assert_received(instance, :to_s) {|expect| expect.twice } }
    assert_fails(message) { assert_matcher_accepts have_received(:to_s).twice, instance }
  end

  def test_should_reject_too_many_calls
    instance = new_instance
    instance.stubs(:to_s)
    2.times { instance.to_s }
    message = /expected exactly once/
    assert_fails(message) { assert_received(instance, :to_s) {|expect| expect.once } }
    assert_fails(message) { assert_matcher_accepts have_received(:to_s).once, instance }
  end

  def assert_fails(message=/not yet invoked/)
    begin
      yield
    rescue Test::Unit::AssertionFailedError => exception
      assert_match message, exception.message, "Test failed, but with the wrong message"
      return
    end
    flunk("Expected to fail")
  end

end

class PartialSpyTest < Test::Unit::TestCase
  include AcceptanceTest
  include SpyTestMethods

  def new_instance
    Object.new
  end
end

class PureSpyTest < Test::Unit::TestCase
  include AcceptanceTest
  include SpyTestMethods

  def new_instance
    stub
  end
end
