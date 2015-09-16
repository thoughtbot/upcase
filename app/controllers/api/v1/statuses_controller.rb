class Api::V1::StatusesController < ApiController
  before_action :doorkeeper_authorize!, unless: :signed_in?

  def create
    StatusUpdater.
      new(completable, current_resource_owner).
      update_state(state)
    track_video_event
    render nothing: true
  end

  private

  def track_video_event
    if completable.is_a? Video
      if state == Status::IN_PROGRESS
        analytics.track_video_started(analytics_properties_for_video)
      elsif state == Status::COMPLETE
        analytics.track_video_finished(analytics_properties_for_video)
      end
    end
  end

  def state
    params[:state]
  end

  def completable
    @completable ||= find_completable
  end

  def find_completable
    if params[:exercise_uuid]
      Exercise.find_by_uuid!(params[:exercise_uuid])
    elsif params[:video_wistia_id]
      Video.find_by_wistia_id!(params[:video_wistia_id])
    end
  end

  def analytics_properties_for_video
    {
      name: completable.name,
      watchable_name: completable.watchable_name,
    }
  end
end
