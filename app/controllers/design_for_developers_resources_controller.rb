class DesignForDevelopersResourcesController < ApplicationController
  layout "d4d_resources"

  def index
  end

  def show
    render params[:id]
  end
end
