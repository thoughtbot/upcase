class TimelinesController < ApplicationController
  before_filter :authorize
  layout 'header-only'

  def show
    authorize_user_viewing_timeline
    @timeline = Timeline.new(timeline_user)
  end

  private

  def authorize_user_viewing_timeline
    if params[:user_id].present? && !current_user_is_admin?
      flash[:error] = 'You do not have permission to view that timeline.'
      redirect_to timeline_path
    end
  end

  def timeline_user
    @timeline_user = User.where(id: params[:user_id]).first || current_user
  end
end
