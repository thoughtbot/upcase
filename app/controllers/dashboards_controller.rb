class DashboardsController < ApplicationController
  before_action :authorize

  def show
    @catalog = Catalog.new
  end
end
