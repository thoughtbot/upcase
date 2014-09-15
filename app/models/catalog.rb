class Catalog
  include ActiveModel::Conversion

  def initialize(user: nil)
    @user = user
  end

  def products
    Product.active.ordered
  end

  def video_tutorials
    VideoTutorial.active
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
    Repository.active.ordered
  end
end
