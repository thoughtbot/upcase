class ProgressBarsController < ApplicationController
  def show
    _trail = Trail.find(params[:trail_id])
    @trail = TrailWithProgress.new(_trail, user: current_user)
  end
end
