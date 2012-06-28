module TopicsHelper
  def format_content(content)
    strip_tags(content).truncate(300)
  end
end
