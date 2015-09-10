require "rails_helper"

feature "subscriber views weekly iteration" do
  scenario "and marks the video complete" do
    show = create(:show, name: "The Weekly Iteration")
    video = create(:video, :published, watchable: show)

    visit show_path(show, as: create(:subscriber))
    expect(video_summary(video)).to have_video_status("unstarted")

    visit video_path(video)
    click_mark_as_complete_button

    expect(video_summary(video)).to have_video_status("complete")
  end

  def video_summary(video)
    find(".video-text", text: video.name)
  end

  def click_mark_as_complete_button
    click_on I18n.t("videos.show.mark-as-complete")
  end

  matcher :have_video_status do |status|
    match do |node|
      node[:class].include? "#{status}"
    end
  end
end
