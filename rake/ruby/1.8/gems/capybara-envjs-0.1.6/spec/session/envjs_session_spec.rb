require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe Capybara::Driver::Envjs do
  session = nil
  before do
    @session = (session ||= Capybara::Session.new(:envjs, TestApp))
  end
  after do
    @session.driver.browser["window"].location = "about:blank"
  end

  describe '#driver' do
    it "should be an envjs driver" do
      @session.driver.should be_an_instance_of(Capybara::Driver::Envjs)
    end
  end

  describe '#mode' do
    it "should remember the mode" do
      @session.mode.should == :envjs
    end
  end

  it_should_behave_like "session"
  it_should_behave_like "session with javascript support"
  it_should_behave_like "session with headers support"
  it_should_behave_like "session with status code support"
end
