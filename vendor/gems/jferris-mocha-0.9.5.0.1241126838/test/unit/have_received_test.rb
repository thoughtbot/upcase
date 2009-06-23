require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'test_runner'
require 'mocha/api'
require 'mocha/mockery'
require 'mocha/object'
require 'matcher_helpers'

module HaveReceivedTestMethods

  include Mocha

  def teardown
    Mockery.reset_instance
  end

  def test_passes_if_invocation_exists
    method = :a_method
    mock   = new_mock('a mock')
    Mockery.instance.invocation(mock, method, [])
    assert_passes do
      assert_matcher_accepts have_received(method), mock
    end
  end

  def test_fails_if_invocation_doesnt_exist
    method = :a_method
    mock   = new_mock('a mock')
    assert_fails do
      assert_matcher_accepts have_received(method), mock
    end
  end

  def test_fails_if_invocation_exists_with_different_arguments
    method = :a_method
    mock   = new_mock('a mock')
    Mockery.instance.invocation(mock, method, [2, 1])
    assert_fails do
      assert_matcher_accepts have_received(method).with(1, 2), mock
    end
  end

  def test_passes_if_invocation_exists_with_wildcard_arguments
    method = :a_method
    mock   = new_mock('a mock')
    Mockery.instance.invocation(mock, method, ['hello'])
    assert_passes do
      assert_matcher_accepts have_received(method).with(is_a(String)), mock
    end
  end

  def test_passes_if_invocation_exists_with_exact_arguments
    method = :a_method
    mock   = new_mock('a mock')
    Mockery.instance.invocation(mock, method, ['hello'])
    assert_passes do
      assert_matcher_accepts have_received(method).with('hello'), mock
    end
  end

  def test_fails_if_invocation_exists_only_on_other_mock
    method = :a_method
    mock   = new_mock('a mock')
    other  = 'another mock'
    Mockery.instance.invocation(other, method, ['hello'])
    assert_fails do
      assert_matcher_accepts have_received(method), mock
    end
  end

  def test_passes_if_invocation_exists_for_impersonating_mock
    method = :a_method
    object = Object.new
    mock   = new_mock('a mock')

    class << object
      attr_accessor :mocha
    end
    object.mocha = mock

    Mockery.instance.invocation(mock, method, ['hello'])
    assert_passes do
      assert_matcher_accepts have_received(method).with('hello'), object
    end
  end

  def test_passes_if_invocation_count_correct
    method = :a_method
    mock   = new_mock('a mock')
    2.times { Mockery.instance.invocation(mock, method, []) }
    assert_passes do
      assert_matcher_accepts have_received(method).twice, mock
    end
  end

  def test_fails_if_invocation_count_incorrect
    method = :a_method
    mock   = new_mock('a mock')
    Mockery.instance.invocation(mock, method, [])
    assert_fails do
      assert_matcher_accepts have_received(method).twice, mock
    end
  end

  def test_fails_if_invocation_count_too_low
    method = :a_method
    mock   = new_mock('a mock')
    Mockery.instance.invocation(mock, method, [])
    assert_fails do
      assert_matcher_accepts have_received(method).twice, mock
    end
  end

  def test_fails_if_invocation_count_too_high
    method = :a_method
    mock   = new_mock('a mock')
    2.times { Mockery.instance.invocation(mock, method, []) }
    assert_fails do
      assert_matcher_accepts have_received(method).once, mock
    end
  end

  def assert_passes(&block)
    assert ! fails?(&block)
  end

  def assert_fails(&block)
    assert fails?(&block)
  end

  def fails?
    begin
      yield
      false
    rescue Test::Unit::AssertionFailedError
      true
    end
  end

end

class PartialHaveReceivedTest < Test::Unit::TestCase

  include TestRunner
  include Mocha::API
  include HaveReceivedTestMethods

  class FakeMock
    def initialize(name)
      @name = name
    end

    def inspect
      @name
    end

    def mocha
      self
    end
  end

  def new_mock(*args)
    FakeMock.new(*args)
  end

end


class PureHaveReceivedTest < Test::Unit::TestCase

  include TestRunner
  include Mocha::API
  include HaveReceivedTestMethods

  class FakeMock
    def initialize(name)
      @name = name
    end

    def inspect
      @name
    end

    def mocha
      self
    end
  end

  def new_mock(*args)
    Mocha::Mock.new(*args)
  end

end
