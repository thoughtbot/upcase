require "rails_helper"

feature "User views show" do
  scenario "with a subscription" do
    create(:basic_plan)
    user = create(:subscriber)
    show = create(:show)
    published_video = create(:video, :published, watchable: show)
    video = create(:video, watchable: show)
    download = create(:download, purchaseable: show)

    visit dashboard_path(as: user)
    click_on show.name
    click_on "Get this Show"

    expect(page).to have_content(show.name)
    expect(page).to have_content(published_video.title)
    expect(page).to have_content(download.display_name)
    expect(page).not_to have_content(video.title)
  end

  scenario "without a subscription" do
    user = create(:user)
    show = create(:show)

    visit dashboard_path(as: user)

    expect(page).not_to have_link_to(show.name)
    expect(page).to have_content("subscribe to Upcase to get access")
  end

  def have_link_to(text)
    have_selector("a", text: text)
  end
end
