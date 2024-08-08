class SlugConstraint
  def initialize(model)
    @model = model
  end

  def matches?(request)
    slug_type(request) == model.to_s
  end

  private

  attr_reader :model

  def slug_type(request)
    requested_slug = request.path_parameters[:id]

    RequestStore.store[:slug_type] ||= Slug
      .find_by(slug: requested_slug)
      .try(:model)
  end
end
