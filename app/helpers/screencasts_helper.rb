module ScreencastsHelper
  def screencast_collection_class(screencast)
    if screencast.collection?
      'group'
    end
  end

  def screecast_video_count(screencast)
    if screencast.collection?
      "(#{screencast.videos.count} videos)"
    end
  end
end
