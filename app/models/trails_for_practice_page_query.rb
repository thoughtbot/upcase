class TrailsForPracticePageQuery
  def self.call
    new.call
  end

  def call
    Trail.
      published.
      by_topic.
      includes(:steps)
  end
end
