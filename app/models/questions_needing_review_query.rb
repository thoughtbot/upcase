class QuestionsNeedingReviewQuery
  CONFIDENCE_THRESHOLD = 4

  def initialize(user)
    @user = user
  end

  def run
    Question.
      all.
      map { |q| q.most_recent_attempt_for(@user) }.
      select { |a| a.confidence > 0 && a.confidence < CONFIDENCE_THRESHOLD }.
      map(&:question)
  end
end
