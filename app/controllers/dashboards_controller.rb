class DashboardsController < ApplicationController
  before_action :authorize

  def show
    render layout: 'header-only'
  end
end
