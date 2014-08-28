class ResourcesController < ApplicationController
  def index
    @topic = TopicsWithResources.new(
      topics: Topic.dashboard,
      factory: TopicWithResourcesFactory.new(catalog: Catalog.new)
    ).find(params[:topic_id])
  end
end
