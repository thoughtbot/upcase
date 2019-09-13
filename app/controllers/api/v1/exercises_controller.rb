class Api::V1::ExercisesController < ApiController
  before_action :doorkeeper_authorize!
  skip_before_action :verify_authenticity_token

  def update
    if authenticated_via_client_credentials_token?
      exercise = Exercise.find_or_initialize_by(uuid: params[:id])

      if exercise.update(exercise_parameters)
        render json: exercise
      else
        render json: { errors: exercise.errors }, status: :unprocessable_entity
      end
    else
      head :unauthorized
    end
  end

  private

  def authenticated_via_client_credentials_token?
    doorkeeper_token.resource_owner_id.nil?
  end

  def exercise_parameters
    params.require(:exercise).permit(:edit_url, :summary, :name, :url)
  end
end
