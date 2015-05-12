class Admin::QuizzesController < ApplicationController
  def index
    @quizzes = Quiz.all
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = build_quiz
    if @quiz.save
      redirect_to admin_quiz_path(@quiz)
    else
      render :new
    end
  end

  def show
    @quiz = find_quiz
  end

  private

  def find_quiz
    Quiz.find(params[:id])
  end

  def build_quiz
    Quiz.new(quiz_params)
  end

  def quiz_params
    params.require(:quiz).permit(:title)
  end
end
