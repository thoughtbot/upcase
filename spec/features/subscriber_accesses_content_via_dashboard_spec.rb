require "rails_helper"

feature "Subscriber accesses content" do
  scenario "begins a workshop" do
    workshop = create(:workshop, :in_dashboard)

    sign_in_as_user_with_subscription
    click_workshop_detail_link

    click_link I18n.t("workshop.checkout_cta")

    expect(page).to have_content I18n.t("licenses.flashes.success")
    expect(page).not_to have_content("Receipt")

    expect_dashboard_to_show_workshop_active(workshop)
  end

  scenario "subscriber without access to workshops attempts to begin a workshop" do
    create(:workshop, :in_dashboard)

    sign_in_as_user_with_downgraded_subscription
    click_workshop_detail_link

    expect(page).to have_content I18n.t("workshop.upgrade_cta")

    click_link I18n.t("workshop.upgrade_cta")

    expect(current_path).to eq edit_subscription_path
  end

  scenario "gets access to a book product" do
    book = create(:book, :github, :in_dashboard)
    sign_in_as_user_with_subscription
    stub_github_fulfillment_job

    click_ebook_detail_link(book)
    click_link I18n.t("book.checkout_cta")

    expect(GithubFulfillmentJob).to have_received(:enqueue).
      with(
        book.github_team,
        @current_user.github_username,
        License.last.id
      )
  end

  scenario "gets access to a screencast" do
    screencast = create(:screencast, :in_dashboard)
    create(:video, :published, watchable: screencast)
    sign_in_as_user_with_subscription
    click_screencast_detail_link(screencast)

    click_link I18n.t("screencast.checkout_cta")

    expect(page).to have_content("Watch or download video")
  end

  scenario "show in-progress status for current workshop" do
    workshop = create(:workshop, :in_dashboard, length_in_days: 2)

    sign_in_as_user_with_subscription
    click_workshop_detail_link
    click_link I18n.t("workshop.checkout_cta")

    visit dashboard_url
    expect(page).to have_css(".card.in-progress", text: workshop.name)
  end

  scenario "show complete status for past workshop" do
    workshop = create(:workshop, :in_dashboard, length_in_days: 2)

    Timecop.travel(3.days.ago) do
      get_access_to_workshop
    end

    visit dashboard_url
    expect(page).to have_css(".card.complete", text: workshop.name)
  end

  def get_access_to_workshop
    sign_in_as_user_with_subscription
    click_workshop_detail_link
    click_link I18n.t("workshop.checkout_cta")
  end

  def stub_github_fulfillment_job
    GithubFulfillmentJob.stubs(:enqueue)
  end

  def click_workshop_detail_link
    find(".workshop > a").click
  end

  def click_screencast_detail_link(screencast)
    within(".screencast") do
      click_link screencast.name
    end
  end

  def click_ebook_detail_link(book)
    click_link book.name
  end

  def expect_dashboard_to_show_workshop_active(workshop)
    visit dashboard_path
    expect(page).to have_css(
      ".card a[title='#{workshop.name}'] .status",
      text: "in-progress"
    )
  end
end
