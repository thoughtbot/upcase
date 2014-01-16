class Catalog
  include ActiveModel::Conversion

  def books
    Book.active.ordered
  end

  def workshops
    Workshop.only_active.by_position
  end

  def screencasts
    Screencast.active.newest_first
  end

  def shows
    Show.active.ordered
  end
end
