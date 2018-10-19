require "rails_helper"

feature "user views video trail" do
  scenario "and marks a video as complete" do
    trail = create_video_trail

    sign_in
    click_on I18n.t("pages.landing.hero_call_to_action")
    click_on trail.name

    within trail_steps_list do
      expect(first_video).to have_status("next-up")
      expect(second_video).to have_status("unstarted")
    end

    click_on first_video_name(trail)
    click_mark_as_complete_button

    within trail_steps_list do
      expect(first_video).to have_status("complete")
      expect(second_video).to have_status("next-up")
    end
  end

  scenario "and can seek to a specific point in the video", js: true do
    video = create(:video, wistia_id: "hello", notes: "# Hello\n\n## Topic")
    marker = create(:marker, video: video, anchor: "topic")

    visit video_path(video, as: create(:user))
    within "#topic" do
      click_jump_to_topic_in_video_button
    end

    expect(current_url).to include("#" + marker.anchor)
  end

  def first_video
    find(".exercise:first-of-type")
  end

  def second_video
    find(".exercise:nth-of-type(2)")
  end

  def first_video_name(trail)
    trail.videos.first.name
  end

  def click_mark_as_complete_button
    click_on I18n.t("videos.show.mark-as-complete")
  end

  def trail_steps_list
    ".exercises-container"
  end

  def click_jump_to_topic_in_video_button
    click_on I18n.t("videos.seek_buttons.jump-to-topic-in-video")
  end

  def create_video_trail
    create(:trail, :published, :with_topic, name: "Video Trail").tap do |trail|
      2.times do
        video = create(:video, watchable: trail)
        create(:step, trail: trail, completeable: video)
      end
    end
  end

  matcher :have_status do |status|
    match do |node|
      node[:class].include? "#{status}-exercise"
    end
  end
end
