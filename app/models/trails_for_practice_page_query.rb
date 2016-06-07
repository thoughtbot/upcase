class TrailsForPracticePageQuery
  include Enumerable

  def each(&block)
    relation.each(&block)
  end

  private

  def relation
    @relation ||= Trail.
      published.
      preload(:topics, steps: :completeable)
  end
end
