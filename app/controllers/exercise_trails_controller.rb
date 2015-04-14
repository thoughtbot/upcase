class ExerciseTrailsController < ApplicationController
  def show
    trail = exercise.trail

    if trail.present?
      redirect_to trail, status: :moved_permanently
    else
      redirect_to root_path, notice: t(".no_trail")
    end
  end

  private

  def exercise
    Exercise.find_by!(uuid: params[:exercise_id])
  end
end
