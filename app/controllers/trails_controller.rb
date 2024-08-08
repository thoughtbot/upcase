class TrailsController < ApplicationController
  def show
    @trail = TrailWithProgressQuery
      .new(Trail.all, user: current_user)
      .find(params[:id])
  end
end
