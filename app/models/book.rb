class Book < Product
  def filename
    name.parameterize
  end

  def included_in_plan?(plan)
    plan.includes_books?
  end
end
