class Catalog
  include ActiveModel::Conversion

  def products
    Product.active.ordered
  end

  def mentors
    Mentor.all
  end

  def individual_plans
    Plan.individual.featured.active.ordered
  end

  def team_plan
    Plan.default_team
  end

  def videos
    Video.published.recently_published_first
  end

  def repositories
    Repository.active.top_level.ordered
  end
end
