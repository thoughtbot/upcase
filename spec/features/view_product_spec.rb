require "rails_helper"

feature "Viewing products" do
  scenario "of different types" do
    create(:basic_plan)
    show = create(
      :show,
      name: "Show",
      short_description: "An awesome show"
    )
    video_tutorial = create(
      :video_tutorial,
      name: "Video",
      short_description: "An awesome video"
    )

    visit show_url(show)

    expect(page).not_to have_content "includes support"
    expect_page_to_have_meta_description(show.short_description)
    expect_page_to_have_title("Show: a show by thoughtbot")

    visit video_tutorial_url(video_tutorial)

    expect(page).not_to have_content "includes support"
    expect_page_to_have_meta_description(video_tutorial.short_description)
    expect_page_to_have_title("Video: a video tutorial by thoughtbot")
  end

  scenario "a user views a product without a subscription or license" do
    video_tutorial = create(
      :video_tutorial,
      name: "Video Tutorial",
      short_description: "An awesome video_tutorial"
    )
    user = create(:user)

    visit video_tutorial_url(video_tutorial, as: user)

    expect_page_to_have_title("Video Tutorial: a video tutorial by thoughtbot")
    expect(page).to have_content(
      "Subscribe to #{I18n.t("shared.subscription.name")}"
    )
  end
end
