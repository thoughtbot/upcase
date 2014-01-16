class Screencast < Product
  def collection?
    videos.count > 1
  end
end
