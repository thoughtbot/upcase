class DashboardsController < ApplicationController
  before_action :authorize

  def show
    @topics = TopicsWithResources.new(
      topics: Topic.dashboard,
      factory: TopicWithResourcesFactory.new(catalog: Catalog.new)
    )
    @topics = @topics.to_a.sort_by(&:count).reverse
  end
end
