class Screencast < Product
  has_many :videos, as: :watchable

  def collection?
    videos.count > 1
  end
end
