class DesignForDevelopersResourcesController < ApplicationController
  layout "d4d_resources"

  def index
  end

  def show
    if template_exists?(params[:id], params[:controller])
      render params[:id]
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
