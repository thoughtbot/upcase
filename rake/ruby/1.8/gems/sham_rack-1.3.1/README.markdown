ShamRack
========

ShamRack plumbs Net:HTTP into [Rack][rack].

What's it for, again?
---------------------

Well, it makes it easy to _stub out external (HTTP) services_, which is handy in development and testing environments, or when you want to _test your HTTP client code_.

You can also use it to _test your Rack application_ (or Sinatra, or Rails, or Merb) using arbitrary HTTP client libraries, to check interoperability. For instance, you could test your app using:

* [`rest-client`][rest-client]
* [`httparty`][httparty]
* [`oauth`][oauth]

all without having to boot it in a server.

Installing it
-------------

    gem install sham_rack

Using it
--------

### A simple inline application

    require 'sham_rack'

    ShamRack.at("www.example.com") do |env|
      ["200 OK", { "Content-type" => "text/plain" }, "Hello, world!"]
    end
      
    require 'open-uri'
    open("http://www.example.com/").read            #=> "Hello, world!"

### Sinatra integration

    ShamRack.at("sinatra.xyz").sinatra do
      get "/hello/:subject" do
        "Hello, #{params[:subject]}"
      end
    end

    open("http://sinatra.xyz/hello/stranger").read  #=> "Hello, stranger"

### Rackup support

    ShamRack.at("rackup.xyz").rackup do
      use Some::Middleware
      use Some::Other::Middleware
      run MyApp.new
    end

### Any old app

    ShamRack.mount(my_google_stub, "google.com")

### General-purpose stubbing

    @stub_app = ShamRack.at("stubbed.com").stub
    @stub_app.register_resource("/greeting", "Hello, world!", "text/plain")
    
    open("http://stubbed.com/greeting").read       #=> "Hello, world!"
    @stub_app.last_request.path                    #=> "/greeting"

Or, just use Sinatra, as described above ... it's almost as succinct, and heaps more powerful.

What's the catch?
-----------------

* Your Rack request-handling code runs in the same Ruby VM, in fact the same Thread, as your request.

Thanks to
---------

* Blaine Cook for [FakeWeb][fakeweb], which was an inspiration for ShamRack.
* Perryn Fowler for his efforts plumbing Net::HTTP into ActionController::TestProcess.
* Christian Neukirchen et al for the chewy goodness that is [Rack][rack].

[rack]: http://rack.rubyforge.org/
[sinatra]: http://www.sinatrarb.com/
[rest-client]: http://github.com/adamwiggins/rest-client
[httparty]: http://github.com/jnunemaker/httparty
[oauth]: http://oauth.rubyforge.org/
[fakeweb]: http://fakeweb.rubyforge.org/
