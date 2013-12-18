class Catalog
  include ActiveModel::Conversion

  def books
    Book.active.ordered
  end

  def in_person_workshops
    Workshop.only_active.by_position.in_person
  end

  def online_workshops
    Workshop.only_active.by_position.online
  end

  def screencasts
    Screencast.active.ordered
  end
end
