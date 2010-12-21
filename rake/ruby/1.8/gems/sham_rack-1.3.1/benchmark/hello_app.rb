require "rubygems"
require "sinatra/base"

class HelloApp < Sinatra::Base

  get "/hello/:subject" do
    "Hello, #{params[:subject]}"
  end
          
end
