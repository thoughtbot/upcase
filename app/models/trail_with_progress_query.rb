class TrailWithProgressQuery
  include Enumerable

  def initialize(relation, user:)
    @relation = relation
    @user = user
  end

  def each
    @relation.each do |trail|
      yield decorate(trail)
    end
  end

  def find(id)
    decorate @relation.find(id)
  end

  private

  def decorate(trail)
    TrailWithProgress.new(
      trail,
      user: @user,
      status_finder: status_finder
    )
  end

  def status_finder
    @status_finder ||= StatusFinder.new(user: @user)
  end
end
