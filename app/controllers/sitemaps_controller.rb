class SitemapsController < ApplicationController
  layout false

  def show
    @weekly_iteration = Show.the_weekly_iteration
    @topics = Topic.explorable
    @trails = Trail.most_recent_published
    @videos = Show.the_weekly_iteration.videos
  end
end
