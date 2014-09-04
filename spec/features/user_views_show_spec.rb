require "rails_helper"

feature "User views show" do
  scenario "with a subscription" do
    create(:basic_plan)
    user = create(:subscriber)
    show = create(:show)
    published_video = create(:video, :published, watchable: show)
    video = create(:video, watchable: show)
    download = create(:download, purchaseable: show)

    visit show_path(show, as: user)
    click_on "Get this Show"

    expect(page).to have_content(show.name)
    expect(page).to have_content(published_video.title)
    expect(page).to have_content(download.display_name)
    expect(page).not_to have_content(video.title)
  end

  def have_link_to(text)
    have_selector("a", text: text)
  end
end
