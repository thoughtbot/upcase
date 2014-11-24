require "rails_helper"

feature "Subscriber accesses content" do
  before do
    show = create(:show, name: Show::THE_WEEKLY_ITERATION)
    create(:video, watchable: show)
  end

  scenario "begins a video_tutorial" do
    pending
    # https://github.com/thoughtbot/upcase/pull/1072
    video_tutorial = create(:video_tutorial)

    sign_in_as_user_with_subscription
    visit explore_path
    click_video_tutorial_detail_link

    click_link I18n.t("video_tutorial.checkout_cta")

    expect(page).to have_content I18n.t("licenses.flashes.success")
    expect(page).not_to have_content("Receipt")

    expect_products_to_show_video_tutorial_active(video_tutorial)
  end

  scenario "subscriber without access to video_tutorials attempts to begin a video_tutorial" do
    pending
    # https://github.com/thoughtbot/upcase/pull/1072
    create(:video_tutorial)

    sign_in_as_user_with_downgraded_subscription
    visit explore_path
    click_video_tutorial_detail_link

    expect(page).to have_content I18n.t("video_tutorial.upgrade_cta")

    click_link I18n.t("video_tutorial.upgrade_cta")

    expect(current_path).to eq edit_subscription_path
  end

  scenario "gets added to the GitHub team for a repository" do
    create(:video_tutorial)
    repository = create(:repository)
    sign_in_as_user_with_subscription
    stub_github_fulfillment_job

    visit explore_path
    click_on "Upcase source code on GitHub"
    click_on repository.name
    click_link I18n.t("repository.checkout_cta")

    expect(GithubFulfillmentJob).
      to have_added_current_user_to_team_for(repository)
  end

  def get_access_to_video_tutorial
    sign_in_as_user_with_subscription
    visit explore_path
    click_video_tutorial_detail_link
    click_link I18n.t("video_tutorial.checkout_cta")
  end

  def stub_github_fulfillment_job
    GithubFulfillmentJob.stubs(:enqueue)
  end

  def click_video_tutorial_detail_link
    find(".video-tutorial a:first").click
  end

  def expect_products_to_show_video_tutorial_active(video_tutorial)
    visit products_path
    expect(page).to have_css(
      ".card a[title='#{video_tutorial.name}'] .status",
      text: "in-progress"
    )
  end

  def have_added_current_user_to_team_for(product)
    have_received(:enqueue).
      with(
        product.github_team,
        @current_user.github_username,
        License.last.id
      )
  end
end
