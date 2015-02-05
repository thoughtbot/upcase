require "rails_helper"

feature "Subscriber accesses content" do
  before do
    show = create(:show, name: Show::THE_WEEKLY_ITERATION)
    create(:video, watchable: show)
    create(:video_tutorial)
  end

  scenario "subscriber without access to video_tutorials attempts to begin a video_tutorial" do
    sign_in_as_user_with_downgraded_subscription
    visit explore_path
    click_video_tutorial_detail_link

    expect(page.body).to include(
      I18n.t("watchables.preview.cta", subscribe_url: subscribe_path).html_safe
    )
    expect(page).to have_content I18n.t("video_tutorial.upgrade_cta")

    click_link I18n.t("video_tutorial.upgrade_cta")

    expect(current_path).to eq edit_subscription_path
  end

  scenario "gets added to the GitHub team for a repository" do
    repository = create(:repository)
    sign_in_as_user_with_subscription
    stub_github_fulfillment_job

    visit explore_path
    click_on "Upcase source code on GitHub"
    click_on repository.name
    click_link I18n.t("repository.view_repository")

    expect(page).to have_content("We're adding you to the GitHub repository")
  end

  def get_access_to_video_tutorial
    sign_in_as_user_with_subscription
    visit explore_path
    click_video_tutorial_detail_link
    click_link I18n.t("video_tutorial.checkout_cta")
  end

  def stub_github_fulfillment_job
    allow(GithubFulfillmentJob).to receive(:enqueue)
  end

  def click_video_tutorial_detail_link
    find(".video-tutorial a:first").click
  end

  def have_added_current_user_to_team_for(product)
    have_received(:enqueue).with(product.id, @current_user.id)
  end
end
