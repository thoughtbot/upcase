require "net/http"
require "sham_rack/registry"
require "sham_rack/http"

class << Net::HTTP  

  alias :new_without_sham_rack :new
  
  def new(address, port = nil, *proxy_args)
    port ||= Net::HTTP.default_port
    rack_app = ShamRack.application_for(address, port)
    http_object = new_without_sham_rack(address, port, *proxy_args)
    if rack_app
      http_object.extend(ShamRack::HTTP::Extensions)
      http_object.rack_app = rack_app
    end
    http_object
  end

end