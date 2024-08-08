class FlashcardsNeedingReviewQuery
  CONFIDENCE_THRESHOLD = 4

  def initialize(user)
    @user = user
  end

  def run
    LatestAttempt.by(@user)
      .confidence_below(CONFIDENCE_THRESHOLD)
      .includes(:flashcard)
      .map(&:flashcard)
  end
end
