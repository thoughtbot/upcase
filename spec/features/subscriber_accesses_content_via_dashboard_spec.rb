require "rails_helper"

feature "Subscriber accesses content" do
  scenario "begins a video_tutorial" do
    video_tutorial = create(:video_tutorial, :in_dashboard)

    sign_in_as_user_with_subscription
    click_video_tutorial_detail_link

    click_link I18n.t("video_tutorial.checkout_cta")

    expect(page).to have_content I18n.t("licenses.flashes.success")
    expect(page).not_to have_content("Receipt")

    expect_dashboard_to_show_video_tutorial_active(video_tutorial)
  end

  scenario "subscriber without access to video_tutorials attempts to begin a video_tutorial" do
    create(:video_tutorial, :in_dashboard)

    sign_in_as_user_with_downgraded_subscription
    click_video_tutorial_detail_link

    expect(page).to have_content I18n.t("video_tutorial.upgrade_cta")

    click_link I18n.t("video_tutorial.upgrade_cta")

    expect(current_path).to eq edit_subscription_path
  end

  scenario "gets access to a screencast" do
    screencast = create(:screencast, :in_dashboard)
    create(:video, :published, watchable: screencast)
    sign_in_as_user_with_subscription
    click_screencast_detail_link(screencast)

    click_link I18n.t("screencast.checkout_cta")

    expect(page).to have_content("Watch or download video")
  end

  scenario "show in-progress status for current video_tutorial" do
    video_tutorial = create(:video_tutorial, :in_dashboard, length_in_days: 2)

    sign_in_as_user_with_subscription
    click_video_tutorial_detail_link
    click_link I18n.t("video_tutorial.checkout_cta")

    visit dashboard_url
    expect(page).to have_css(".card.in-progress", text: video_tutorial.name)
  end

  scenario "show complete status for past video_tutorial" do
    video_tutorial = create(:video_tutorial, :in_dashboard, length_in_days: 2)

    Timecop.travel(3.days.ago) do
      get_access_to_video_tutorial
    end

    visit dashboard_url
    expect(page).to have_css(".card.complete", text: video_tutorial.name)
  end

  def get_access_to_video_tutorial
    sign_in_as_user_with_subscription
    click_video_tutorial_detail_link
    click_link I18n.t("video_tutorial.checkout_cta")
  end

  def stub_github_fulfillment_job
    GithubFulfillmentJob.stubs(:enqueue)
  end

  def click_video_tutorial_detail_link
    find(".video_tutorial > a").click
  end

  def click_screencast_detail_link(screencast)
    within(".screencast") do
      click_link screencast.name
    end
  end

  def expect_dashboard_to_show_video_tutorial_active(video_tutorial)
    visit dashboard_path
    expect(page).to have_css(
      ".card a[title='#{video_tutorial.name}'] .status",
      text: "in-progress"
    )
  end
end
