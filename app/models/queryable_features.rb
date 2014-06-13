module QueryableFeatures
  def includes_mentor?
    FeatureQuery.new(features).includes_mentor?
  end

  def includes_workshops?
    FeatureQuery.new(features).includes_workshops?
  end
end
