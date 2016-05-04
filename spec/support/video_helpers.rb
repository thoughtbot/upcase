module VideoHelpers
  def create_video_on_a_trail(trail: create(:trail))
    video = create(:video)
    create(:step, trail: trail, completeable: video)
    video.reload
  end
end
