class Admin::FlashcardsController < ApplicationController
  def new
    @quiz = find_quiz
    @flashcard = @quiz.flashcards.new
  end

  def create
    @quiz = find_quiz
    @flashcard = @quiz.flashcards.create(flashcard_params)

    if @flashcard.save
      redirect_to admin_quiz_path(@quiz)
    else
      render :new
    end
  end

  def edit
    @quiz = find_quiz
    @flashcard = @quiz.flashcards.find(params[:id])
  end

  def update
    @quiz = find_quiz
    @flashcard = @quiz.flashcards.find(params[:id])

    @flashcard.update(flashcard_params)

    redirect_to admin_quiz_path(@quiz)
  end

  private

  def find_quiz
    Quiz.find(params[:quiz_id])
  end

  def flashcard_params
    params.require(:flashcard).permit(:title, :prompt, :answer, :position)
  end
end
