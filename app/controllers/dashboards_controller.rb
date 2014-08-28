class DashboardsController < ApplicationController
  before_action :authorize

  def show
    @topics = TopicsWithResources.new(
      topics: Topic.dashboard,
      factory: TopicWithResourcesFactory.new(catalog: Catalog.new)
    )
  end
end
