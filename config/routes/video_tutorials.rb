resources :video_tutorials, only: [] do
  resources :licenses, only: [:create]
end

get(
  ":id" => "video_tutorials#show",
  as: :video_tutorial,
  constraints: LicenseableConstraint.new(VideoTutorial)
)
