class TrailsController < ApplicationController
  def index
    @topics = Topic.top
  end

  def show
    @trail = TrailWithProgress.new(Trail.find(params[:id]), user: current_user)
  end
end
