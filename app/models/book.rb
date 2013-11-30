class Book < Product
  def filename
    name.parameterize
  end
end
