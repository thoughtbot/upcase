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

  scenario "and sees priority trails first" do
    topic = create(:topic, :explorable)
    subscriber = create(:subscriber)
    not_priority_trail = create(:trail, :published, :video)
    priority_trail = create(:trail, :published, :video, priority: 1)
    topic.trails << not_priority_trail
    topic.trails << priority_trail

    visit topic_path(topic, as: subscriber)

    expect(priority_trail.name).to appear_before(not_priority_trail.name)
  end
end
