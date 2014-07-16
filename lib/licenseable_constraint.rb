class LicenseableConstraint
  def initialize(model)
    @model = model
  end

  def matches?(request)
    @model.exists?(slug: request.path_parameters[:id])
  end
end
