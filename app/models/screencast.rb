class Screencast < Product
  def collection?
    published_videos.count > 1
  end
end
