require "rails_helper"

describe "user views video tutorial" do
  it "with a subscription" do
    user = create(:user, :with_full_subscription)
    video_tutorial = create(:video_tutorial, resources: "* Item 1\n*Item 2")
    create(:video, watchable: video_tutorial)

    visit video_tutorial_path(video_tutorial, as: user)

    expect_page_to_not_have_preview_cta
    expect(page).to have_content(video_tutorial.name)
    expect(page).to have_css('.resources li', text: 'Item 1')
  end

  def expect_page_to_not_have_preview_cta
    expect(page.body).not_to include(
      I18n.t("watchables.preview.cta", subscribe_url: subscribe_path).html_safe
    )
  end
end
