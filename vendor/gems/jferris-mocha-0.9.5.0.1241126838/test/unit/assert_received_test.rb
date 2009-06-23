require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'test_runner'
require 'mocha/api'
require 'mocha/mockery'
require 'mocha/object'

class AssertReceivedTest < Test::Unit::TestCase

  include Mocha
  include TestRunner
  include Mocha::API

  def teardown
    Mockery.reset_instance
  end

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

  def test_passes_if_invocation_exists
    method = :a_method
    mock   = FakeMock.new('a mock')
    Mockery.instance.invocation(mock, method, [])
    assert_passes do
      assert_received(mock, method)
    end
  end

  def test_fails_if_invocation_doesnt_exist
    method = :a_method
    mock   = FakeMock.new('a mock')
    assert_fails do
      assert_received(mock, method)
    end
  end

  def test_fails_if_invocation_exists_with_different_arguments
    method = :a_method
    mock   = FakeMock.new('a mock')
    Mockery.instance.invocation(mock, method, [2, 1])
    assert_fails do
      assert_received(mock, method) {|expect| expect.with(1, 2) }
    end
  end

  def test_passes_if_invocation_exists_with_wildcard_arguments
    method = :a_method
    mock   = FakeMock.new('a mock')
    Mockery.instance.invocation(mock, method, ['hello'])
    assert_passes do
      assert_received(mock, method) {|expect| expect.with(is_a(String)) }
    end
  end

  def test_passes_if_invocation_exists_with_exact_arguments
    method = :a_method
    mock   = FakeMock.new('a mock')
    Mockery.instance.invocation(mock, method, ['hello'])
    assert_passes do
      assert_received(mock, method) {|expect| expect.with('hello') }
    end
  end

  def test_fails_if_invocation_exists_only_on_other_mock
    method = :a_method
    mock   = FakeMock.new('a mock')
    other  = 'another mock'
    Mockery.instance.invocation(other, method, ['hello'])
    assert_fails do
      assert_received(mock, method)
    end
  end

  def test_passes_if_invocation_exists_for_impersonating_mock
    method = :a_method
    object = Object.new
    mock   = FakeMock.new('a mock')

    class << object
      attr_accessor :mocha
    end
    object.mocha = mock

    Mockery.instance.invocation(mock, method, ['hello'])
    assert_passes do
      assert_received(object, method) {|expect| expect.with('hello') }
    end
  end

  def test_passes_if_invocation_count_correct
    method = :a_method
    mock   = FakeMock.new('a mock')
    2.times { Mockery.instance.invocation(mock, method, []) }
    assert_passes do
      assert_received(mock, method) {|expect| expect.twice }
    end
  end

  def test_fails_if_invocation_count_too_low
    method = :a_method
    mock   = FakeMock.new('a mock')
    Mockery.instance.invocation(mock, method, [])
    assert_fails do
      assert_received(mock, method) {|expect| expect.twice }
    end
  end

  def test_fails_if_invocation_count_too_high
    method = :a_method
    mock   = FakeMock.new('a mock')
    2.times { Mockery.instance.invocation(mock, method, []) }
    assert_fails do
      assert_received(mock, method) {|expect| expect.once }
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
