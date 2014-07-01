# Represents the lack of a plan, i.e. a plan with no features
class NullPlan
  def has_feature?(feature)
    false
  end
end
