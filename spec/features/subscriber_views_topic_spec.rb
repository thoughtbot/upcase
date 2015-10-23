require "rails_helper"

feature "Subscriber views a topic" do
  scenario "and sees associated resources" do
    topic = create(:topic, :explorable)
    subscriber = create(:subscriber)
    video = create(:video, watchable: create(:the_weekly_iteration))
    trail = create(:trail, :published, :video)
    topic.videos << video
    topic.trails << trail

    visit topic_path(topic, as: subscriber)

    expect(page).to have_content(video.name)
    expect(page).to have_content(trail.name)
  end
end
