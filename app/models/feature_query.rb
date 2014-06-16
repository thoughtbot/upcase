class FeatureQuery
  def initialize(relation)
    @relation = relation
  end

  def includes_workshops?
    @relation.where(key: Feature::WORKSHOPS_KEY).present?
  end

  def includes_mentor?
    @relation.where(key: Feature::MENTORING_KEY).present?
  end
end
