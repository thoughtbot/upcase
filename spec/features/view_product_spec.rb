require "rails_helper"

feature "Viewing products" do
  scenario "of different types" do
    create(:basic_plan)
    show = create(
      :show,
      name: "Show",
      short_description: "An awesome show"
    )
    screencast = create(
      :screencast,
      name: "Video",
      short_description: "An awesome video"
    )

    visit show_url(show)

    expect(page).not_to have_content "includes support"
    expect_page_to_have_meta_description(show.short_description)
    expect_page_to_have_title("Show: a show by thoughtbot")

    visit screencast_url(screencast)

    expect(page).not_to have_content "includes support"
    expect_page_to_have_meta_description(screencast.short_description)
    expect_page_to_have_title("Video: a screencast by thoughtbot")
  end

  scenario "that are inactive" do
    product = create(:screencast, :inactive)

    visit screencast_url(product)

    expect(page).not_to have_content "Purchase for Yourself"
    expect(page).to have_content(
      "This screencast is not currently available."
    )
  end

  scenario "a user views a product without a subscription or license" do
    screencast = create(
      :screencast,
      name: "Screencast",
      short_description: "An awesome screencast"
    )
    user = create(:user)

    visit screencast_url(screencast, as: user)

    expect_page_to_have_title("Screencast: a screencast by thoughtbot")
    expect(page).to have_content(
      "Subscribe to #{I18n.t("shared.subscription.name")}"
    )
  end

  scenario "a user views a product with a license without a subscription" do
    show = create(:show, name: "show title")
    show.published_videos.create(attributes_for(:video))

    user = create(:user)
    create(:license, user: user, licenseable: show)

    visit show_url(show, as: user)

    expect(page).to have_content("show title")
    expect(page).to_not have_content(
      "Subscribe to #{I18n.t("shared.subscription.name")}"
    )
  end
end
