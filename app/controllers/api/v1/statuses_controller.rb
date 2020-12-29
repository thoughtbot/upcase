class Api::V1::StatusesController < ApiController
  before_action :doorkeeper_authorize!, unless: :signed_in?

  def create
    StatusUpdater.
      new(completeable, current_resource_owner).
      update_state(state)
    head :ok
  end

  private

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
end
