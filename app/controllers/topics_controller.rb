class TopicsController < ApplicationController
  def index
    expires_in 12.hours, public: true
    @topics = Topic.top
  end

  def show
    expires_in 12.hours, public: true
    @topic = Topic.find_by_slug!(params[:id])
  end
end
