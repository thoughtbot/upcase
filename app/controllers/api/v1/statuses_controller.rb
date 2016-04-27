class Api::V1::StatusesController < ApiController
  before_action :doorkeeper_authorize!, unless: :signed_in?

  def create
    StatusUpdater.
      new(completeable, current_resource_owner).
      update_state(state)
    track_event
    render nothing: true
  end

  private

  def track_event
    if state == Status::IN_PROGRESS
      analytics.track_completeable_started(completeable)
    elsif state == Status::COMPLETE
      analytics.track_completeable_finished(completeable)
    end
  end

  def state
    params[:state]
  end

  def completeable
    @completeable ||= find_completeable
  end

  def find_completeable
    if params[:exercise_uuid]
      Exercise.find_by!(uuid: params[:exercise_uuid])
    elsif params[:video_wistia_id]
      Video.find_by!(wistia_id: params[:video_wistia_id])
    end
  end

  def analytics
    Analytics.new(current_resource_owner)
  end
end
