class DashboardsController < ApplicationController
  before_action :authorize

  def show
    @catalog = Catalog.new
    render layout: 'header-only'
  end
end
