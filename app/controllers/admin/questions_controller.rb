class Admin::QuestionsController < ApplicationController
  def new
    @quiz = find_quiz
    @question = @quiz.questions.new
  end

  def create
    @quiz = find_quiz
    @question = @quiz.questions.create(question_params)

    if @question.save
      redirect_to admin_quiz_path(@quiz)
    else
      render :new
    end
  end

  def edit
    @quiz = find_quiz
    @question = @quiz.questions.find(params[:id])
  end

  def update
    @quiz = find_quiz
    @question = @quiz.questions.find(params[:id])

    @question.update(question_params)

    redirect_to admin_quiz_path(@quiz)
  end

  private

  def find_quiz
    Quiz.find(params[:quiz_id])
  end

  def question_params
    params.require(:question).permit(:title, :prompt, :answer, :position)
  end
end
