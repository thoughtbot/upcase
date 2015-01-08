class Api::V1::StatusesController < ApiController
  before_action :doorkeeper_authorize!, unless: :signed_in?

  def create
    completable.statuses.create!(
      user: current_resource_owner,
      state: params[:state]
    )
    completable.update_trails_state_for(current_resource_owner)
    analytics.track_status_created(completable, params[:state])
    render nothing: true
  end

  private

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

  def analytics
    Analytics.new(current_user)
  end
end
