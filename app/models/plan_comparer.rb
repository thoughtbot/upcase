# For calculating which features have been gained or lost when
# a user changes plans
class PlanComparer
  def initialize(new_plan:, old_plan:)
    @old_plan = old_plan
    @new_plan = new_plan
  end

  def features_gained
    all_features.select do |feature|
      !@old_plan.has_feature?(feature) &&
        @new_plan.has_feature?(feature)
    end
  end

  def features_lost
    all_features.select do |feature|
      @old_plan.has_feature?(feature) &&
        !@new_plan.has_feature?(feature)
    end
  end

  private

  def all_features
    Features::Factory::ALL_FEATURES
  end
end
