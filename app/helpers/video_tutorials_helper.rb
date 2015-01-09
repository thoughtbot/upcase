module VideoTutorialsHelper
  def video_tutorials_json(video_tutorials, callback = nil)
    json = video_tutorials.map! do |video_tutorial|
      video_tutorial_json = { "video_tutorial" => video_tutorial.as_json }
      video_tutorial_json["video_tutorial"].merge!(
        url: video_tutorial_url(video_tutorial))
      video_tutorial_json
    end.to_json
    json = "#{callback}(#{json})" if callback
    json.html_safe
  end
end
