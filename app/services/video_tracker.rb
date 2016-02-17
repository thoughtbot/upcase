class VideoTracker
  def initialize(video)
    @video = video
  end

  def started_events
    [
      [
        "Started video",
        {
          name: video.name,
          watchable_name: video.watchable_name,
        },
      ], [
        "Touched Video",
        {
          name: video.name,
          watchable_name: video.watchable_name,
        },
      ], [
        "Touched Step",
        {
          name: video.name,
          watchable_name: video.watchable_name,
          type: "Video",
        },
      ]
    ]
  end

  def finished_events
    [
      [
        "Finished video",
        {
          name: video.name,
          watchable_name: video.watchable_name,
        },
      ],
    ]
  end

  private

  attr_reader :video
end
