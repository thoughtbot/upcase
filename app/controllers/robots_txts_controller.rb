class RobotsTxtsController < ApplicationController
  def show
    options = { layout: false, content_type: "text/plain" }

    if Rails.env.production?
      render "default", options
    else
      render "disallow_all", options
    end
  end
end
