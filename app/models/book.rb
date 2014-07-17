class Book < Product
  def filename
    name.parameterize
  end

  def included_in_plan?(plan)
    plan.has_feature?(:books)
  end
end
