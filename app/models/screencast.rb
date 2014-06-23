class Screencast < Product
  def collection?
    published_videos.count > 1
  end

  def included_in_plan?(plan)
    plan.includes_screencasts?
  end
end
