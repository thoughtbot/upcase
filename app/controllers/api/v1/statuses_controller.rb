class Api::V1::StatusesController < ApiController
  def create
    exercise.statuses.create!(user: resource_owner, state: params[:state])
    render nothing: true
  end

  private

  def exercise
    Exercise.find_by!(uuid: params[:exercise_uuid])
  end
end
