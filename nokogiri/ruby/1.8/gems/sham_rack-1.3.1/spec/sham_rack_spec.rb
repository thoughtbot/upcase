require "spec_helper"

require "sham_rack"
require "open-uri"
require "restclient"
require "mechanize"
require "rack"

class PlainTextApp

  def call(env)
    [
      "200 OK", 
      { "Content-Type" => "text/plain", "Content-Length" => message.length.to_s },
      [message]
    ]
  end

end

class SimpleMessageApp < PlainTextApp

  def initialize(message)
    @message = message
  end

  attr_reader :message

end

class EnvRecordingApp < PlainTextApp

  def call(env)
    @last_env = env
    super
  end

  attr_reader :last_env

  def message
    "env stored for later perusal"
  end

end

class UpcaseBody

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    upcased_body = Array(body).map { |x| x.upcase }
    [status, headers, upcased_body]
  end

end

describe ShamRack do

  after(:each) do
    ShamRack.unmount_all
  end

  describe "mounted Rack application" do

    before(:each) do
      ShamRack.mount(SimpleMessageApp.new("Hello, world"), "www.test.xyz")
    end

    it "can be accessed using Net::HTTP" do
      response = Net::HTTP.start("www.test.xyz") do |http|
        http.request(Net::HTTP::Get.new("/"))
      end
      response.body.should == "Hello, world"
    end

    it "can be accessed using Net::HTTP#get_response" do
      response = Net::HTTP.get_response(URI.parse("http://www.test.xyz/"))
      response.body.should == "Hello, world"
    end

    it "can be accessed using open-uri" do
      response = open("http://www.test.xyz")
      response.status.should == ["200", "OK"]
      response.read.should == "Hello, world"
    end

    it "can be accessed using RestClient" do
      response = RestClient.get("http://www.test.xyz")
      response.code.should == 200
      response.to_s.should == "Hello, world"
    end

    it "can be accessed using WWW::Mechanize" do
      response = Mechanize.new.get("http://www.test.xyz")
      response.body.should == "Hello, world"
    end

  end

  describe "response" do
    
    before(:each) do
      ShamRack.at("www.test.xyz") do
        [
          "201 Created", 
          { "Content-Type" => "text/plain", "X-Foo" => "bar" },
          "BODY"
        ]
      end
      @response = Net::HTTP.get_response(URI.parse("http://www.test.xyz/"))
    end
    
    it "has status returned by app" do
      @response.code.should == "201"
    end

    it "has body returned by app" do
      @response.body.should == "BODY"
    end
    
    it "has Content-Type returned by app" do
      @response.content_type.should == "text/plain"
    end
    
    it "has other headers returned by app" do
      @response["x-foo"].should =="bar"
    end
    
  end
  
  describe ".at" do

    describe "with a block" do

      it "mounts associated block as an app" do

        ShamRack.at("simple.xyz") do |env|
          ["200 OK", { "Content-type" => "text/plain" }, "Easy, huh?"]
        end

        open("http://simple.xyz").read.should == "Easy, huh?"

      end

    end

    describe "#rackup" do

      before do
        @return_value = ShamRack.at("rackup.xyz").rackup do
          use UpcaseBody
          run SimpleMessageApp.new("Racked!")
        end
      end

      it "mounts an app created using Rack::Builder" do
        open("http://rackup.xyz").read.should == "RACKED!"
      end

      it "returns the app" do
        @return_value.should respond_to(:call)
      end

    end

    describe "#sinatra" do

      before do
        @return_value = ShamRack.at("sinatra.xyz").sinatra do
          get "/hello/:subject" do
            "Hello, #{params[:subject]}"
          end
        end
      end
      
      it "mounts associated block as a Sinatra app" do
        open("http://sinatra.xyz/hello/stranger").read.should == "Hello, stranger"
      end

      it "returns the app" do
        @return_value.should respond_to(:call)
      end
      
    end

    describe "#stub" do
      
      before do
        @return_value = ShamRack.at("stubbed.xyz").stub
      end

      it "mounts a StubWebService" do
        ShamRack.application_for("stubbed.xyz").should be_kind_of(ShamRack::StubWebService)
      end
      
      it "returns the StubWebService" do
        @return_value.should == ShamRack.application_for("stubbed.xyz")
      end
      
    end
    
  end

  describe "Rack environment" do

    before(:each) do
      @env_recorder = recorder = EnvRecordingApp.new
      ShamRack.at("env.xyz").rackup do
        use Rack::Lint
        run recorder
      end
    end

    def env
      @env_recorder.last_env
    end

    it "is valid" do

      open("http://env.xyz/blah?q=abc")

      env["REQUEST_METHOD"].should == "GET"
      env["SCRIPT_NAME"].should == ""
      env["PATH_INFO"].should == "/blah"
      env["QUERY_STRING"].should == "q=abc"
      env["SERVER_NAME"].should == "env.xyz"
      env["SERVER_PORT"].should == "80"

      env["rack.version"].should == [0,1]
      env["rack.url_scheme"].should == "http"

      env["rack.multithread"].should == true
      env["rack.multiprocess"].should == true
      env["rack.run_once"].should == false

    end

    it "provides request headers" do

      Net::HTTP.start("env.xyz") do |http|
        request = Net::HTTP::Get.new("/")
        request["Foo-bar"] = "baz"
        http.request(request)
      end

      env["HTTP_FOO_BAR"].should == "baz"

    end

    it "supports POST" do

      RestClient.post("http://env.xyz/resource", "q" => "rack")

      env["REQUEST_METHOD"].should == "POST"
      env["CONTENT_TYPE"].should == "application/x-www-form-urlencoded"
      env["rack.input"].read.should == "q=rack"

    end

    it "supports POST using Net::HTTP" do

      Net::HTTP.start("env.xyz") do |http|
        http.post("/resource", "q=rack")
      end

      env["REQUEST_METHOD"].should == "POST"
      env["rack.input"].read.should == "q=rack"

    end

    it "supports PUT" do

      RestClient.put("http://env.xyz/thing1", "stuff", :content_type => "text/plain")

      env["REQUEST_METHOD"].should == "PUT"
      env["CONTENT_TYPE"].should == "text/plain"
      env["rack.input"].read.should == "stuff"

    end

    it "supports DELETE" do

      RestClient.delete("http://env.xyz/thing/1")

      env["REQUEST_METHOD"].should == "DELETE"
      env["PATH_INFO"].should == "/thing/1"

    end

  end

end
