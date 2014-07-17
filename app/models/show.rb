class Show < Product
  THE_WEEKLY_ITERATION = 'The Weekly Iteration'

  def self.the_weekly_iteration
    where(name: THE_WEEKLY_ITERATION).first
  end

  def included_in_plan?(plan)
    plan.has_feature?(:shows)
  end

  private

  def product_licenses
    []
  end
end
