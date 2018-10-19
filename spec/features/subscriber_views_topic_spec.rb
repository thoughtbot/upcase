require "rails_helper"

feature "user views a topic" do
  scenario "and sees associated resources" do
    topic = create(:topic, :explorable)
    user = create(:user)
    video = create(:video, watchable: create(:the_weekly_iteration))
    trail = create(:trail, :published, :video)
    topic.videos << video
    topic.trails << trail

    visit topic_path(topic, as: user)

    expect(page).to have_content(video.name)
    expect(page).to have_content(trail.name)
  end
end
