require "spec_helper"

require "sham_rack/stub_web_service"
require "rack/test"

describe ShamRack::StubWebService do

  include Rack::Test::Methods

  attr_reader :app

  before(:each) do
    @app = ShamRack::StubWebService.new
  end

  describe "#last_request" do
    
    it "returns the last request" do
      get '/foo/bar'
      @app.last_request.path_info.should == "/foo/bar"
    end
    
  end
  
  describe "with no handlers registered" do

    describe "any request" do

      before do
        get "/foo/456"
      end

      it "returns a 404" do
        last_response.status.should == 404
      end

    end

  end

  describe "with two handlers registered" do
    
    before(:each) do
      
      @app.handle do |request|
        [200, {}, "response from first handler"] if request.get?
      end

      @app.handle do |request|
        [200, {}, "response from second handler"] if request.path_info == "/stuff"
      end
      
    end
      
    describe "a request matching the first handler" do

      before do
        get "/foo/456"
      end

      it "receives a response from the first handler" do
        last_response.body.should == "response from first handler"
      end
      
    end
    
    describe "a request matching the second handler" do

      before do
        post "/stuff"
      end

      it "receives a response from the second handler" do
        last_response.body.should == "response from second handler"
      end
      
    end
    
    describe "a request matching both handlers" do

      before do
        get "/stuff"
      end

      it "receives a response from the second handler" do
        last_response.body.should == "response from second handler"
      end
      
    end
    
  end

  describe ".register_resource" do

    before do
      @app.register_resource("/stuff?foo=bar", "STUFF", "text/plain", 202)
      get "/stuff?foo=bar"
    end
      
    it "sets body" do
      last_response.body.should == "STUFF"
    end

    it "sets content-type" do
      last_response.content_type.should == "text/plain"
    end
    
    it "sets status code" do
      last_response.status.should == 202
    end

  end

end
