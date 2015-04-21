require "rails_helper"

feature "Subscriber views a topic" do
  scenario "and sees associated resources" do
    create(:show, name: Show::THE_WEEKLY_ITERATION)
    topic = create(:topic, :explorable)
    video = create(:video)
    trail = create(:trail, :published, :video)
    topic.videos << video
    topic.trails << trail

    visit explore_path(as: create(:subscriber))
    click_on topic.name

    expect(page).to have_content(video.name)
    expect(page).to have_content(trail.name)
  end
end
