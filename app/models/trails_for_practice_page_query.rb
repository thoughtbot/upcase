class TrailsForPracticePageQuery
  include Enumerable

  def each(&)
    relation.each(&)
  end

  private

  def relation
    @relation ||= Trail
      .published
      .preload(:topics, steps: :completeable)
  end
end
