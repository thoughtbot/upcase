class TrailsForPracticePageQuery
  include Enumerable

  def each(&block)
    relation.each(&block)
  end

  private

  def relation
    @relation ||= Trail.
      published.
      by_topic.
      preload(steps: :completeable)
  end
end
