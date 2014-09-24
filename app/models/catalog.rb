class Catalog
  include ActiveModel::Conversion

  def products
    Product.active.ordered
  end

  def video_tutorials
    VideoTutorial.active
  end

  def shows
    Show.active.ordered
  end

  def exercises
    Exercise.ordered
  end

  def mentors
    Mentor.all
  end

  def individual_plans
    Plan.individual.featured.active.ordered
  end

  def videos
    Video.published.recently_published_first
  end

  def repositories
    Repository.active.ordered
  end
end
