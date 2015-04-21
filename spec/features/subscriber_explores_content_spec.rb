require "rails_helper"

feature "Subscriber accesses content" do
  before do
    show = create(:show, name: Show::THE_WEEKLY_ITERATION)
    create(:video, watchable: show)
    create(:trail, :published, :video)
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

  def stub_github_fulfillment_job
    allow(GithubFulfillmentJob).to receive(:enqueue)
  end

  def have_added_current_user_to_team_for(product)
    have_received(:enqueue).with(product.id, @current_user.id)
  end
end
