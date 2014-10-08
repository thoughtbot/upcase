class ResourcesController < ApplicationController
  def index
    @topic = TopicsWithResources.new(
      topics: Topic.dashboard,
      factory: TopicWithResourcesFactory.new(
        catalog: Catalog.new(user: current_user)
      )
    ).find(params[:topic_id])
  end
end
