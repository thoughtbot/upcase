class TrailsController < ApplicationController
  def show
    @trail = TrailWithProgress.new(Trail.find(params[:id]), user: current_user)
  end
end
