require "rails_helper"

feature "User views show" do
  scenario "with a subscription" do
    user = create(:subscriber)
    show = create(:show)
    published_video = create(:video, :published, watchable: show)
    video = create(:video, watchable: show)
    download = create(:download, purchaseable: show)

    visit show_path(show, as: user)

    expect(page).to have_content(show.name)
    expect(page).to have_content(published_video.title)
    expect(page).to have_content(download.display_name)
    expect(page).not_to have_content(video.title)

    click_on published_video.title

    expect_page_to_have_title("#{published_video.title} | Upcase")
  end

  def have_link_to(text)
    have_selector("a", text: text)
  end
end
