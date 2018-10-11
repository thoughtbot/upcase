class TrailsController < ApplicationController
  cache_signed_out_action :show

  def show
    @trail = TrailWithProgressQuery.
      new(Trail.all, user: current_user).
      find(params[:id])
  end
end
