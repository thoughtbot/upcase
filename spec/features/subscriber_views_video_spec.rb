require "rails_helper"

feature "subscriber views video trail" do
  scenario "and marks a video as complete" do
    trail = create_video_trail

    sign_in_as_user_with_subscription
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

  def create_video_trail
    create(:trail, :published, name: "Video Trail").tap do |trail|
      2.times do
        video = create(:video)
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
