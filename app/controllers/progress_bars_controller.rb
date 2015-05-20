class ProgressBarsController < ApplicationController
  def show
    @trail_with_progress = build_trail_with_progress

    render layout: false
  end

  private

  def build_trail_with_progress
    trail = Trail.find(params[:trail_id])
    TrailWithProgress.new(trail, user: current_user)
  end
end
