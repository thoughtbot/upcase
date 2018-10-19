class Catalog
  include ActiveModel::Conversion

  def products
    Product.active.ordered
  end

  def videos
    Video.published.recently_published_first
  end

  def repositories
    Repository.active.top_level.ordered
  end
end
