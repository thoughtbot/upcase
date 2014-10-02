class DashboardsController < ApplicationController
  before_action :authorize

  def show
    @dashboard = Dashboard.new(current_user)
  end
end
