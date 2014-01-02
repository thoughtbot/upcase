require 'action_controller/metal/exceptions'

class IgnoreMissingProductImage
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ActionController::RoutingError => e
    if e.message =~ %r{(?:product_images|workshop_thumbs)/.+\.(png|jpg)}
      [200, { 'Content-Type' => "image/#{$1}", 'Content-Length' => 0 }, ['']]
    else
      raise e
    end
  end
end
