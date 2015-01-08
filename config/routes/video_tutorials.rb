get(
  ":id" => "video_tutorials#show",
  as: :video_tutorial,
  constraints: SlugConstraint.new(VideoTutorial)
)
