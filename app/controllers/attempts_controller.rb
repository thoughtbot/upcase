class AttemptsController < ApplicationController
  before_action :require_login

  def create
    attempt = flashcard.attempts.create!(attempt_params)

    if attempt.low_confidence?
      flash[:notice] = I18n.t("attempts.flashcard_saved")
    end

    redirect_to_next_flashcard_or_results(flashcard)
  end

  def update
    attempt = current_user.attempts.find(params[:id])
    attempt.update_attribute(:confidence, params[:confidence])

    redirect_to(
      decks_path,
      notice: I18n.t("attempts.flashcard_removed_from_review_queue")
    )
  end

  private

  def redirect_to_next_flashcard_or_results(flashcard)
    if flashcard.next
      redirect_to deck_flashcard_path(flashcard.deck, flashcard.next)
    else
      redirect_to deck_results_path(flashcard.deck)
    end
  end

  def attempt_params
    params.require(:attempt).permit(:confidence).merge(user: current_user)
  end

  def flashcard
    @_flashcard ||= Flashcard.find(params[:flashcard_id])
  end
end
