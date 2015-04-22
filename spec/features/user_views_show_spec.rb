require "rails_helper"

feature "User views show" do
  scenario "with a subscription" do
    user = create(:subscriber)
    show = create(:show)
    published_video = create(:video, :published, watchable: show)
    video = create(:video, watchable: show)

    visit show_path(show, as: user)

    expect(page).to have_content(show.name)
    expect(page).to have_content(published_video.name)
    expect(page).not_to have_content(video.name)
    expect(page.body).not_to include(preview_cta)

    click_on published_video.name

    expect(page.body).not_to include(preview_cta)
    expect_page_to_have_title("#{published_video.name} | Upcase")
  end

  scenario "without a subscription" do
    user = create(:user)
    show = create(:show, name: "TWI", short_description: "a show about code")
    published_video = create(:video, :published, watchable: show)

    visit show_path(show, as: user)

    expect(page).to have_content(show.name)
    expect(page.body).to include(preview_cta)
    expect(page).not_to have_content "includes support"
    expect_page_to_have_meta_description(show.short_description)
    expect_page_to_have_title("TWI: a show by thoughtbot")
    expect(page).to have_content(
      "Subscribe to #{I18n.t('shared.subscription.name')}"
    )

    click_on published_video.name

    expect(page.body).to include(preview_cta)
    expect_page_to_have_title(show.name)
  end

  def have_link_to(text)
    have_selector("a", text: text)
  end

  def preview_cta
    I18n.t("watchables.preview.cta", subscribe_url: subscribe_path).html_safe
  end
end
