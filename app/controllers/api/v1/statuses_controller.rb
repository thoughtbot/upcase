class Api::V1::StatusesController < ApiController
  doorkeeper_for :all

  def create
    exercise.statuses.create!(user: resource_owner, state: params[:state])
    exercise.update_trails_state_for(resource_owner)
    render nothing: true
  end

  private

  def exercise
    @exercise ||= Exercise.find_by!(uuid: params[:exercise_uuid])
  end
end
