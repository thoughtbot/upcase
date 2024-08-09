require "rails_helper"

describe "videos/_access_callout" do
  context "when there is a preview available" do
    it "displays the 'preview' message and CTA" do
      video = build_stubbed(:video, :with_preview)

      render_callout video, signed_out: true

      expect_to_have_callout_content_with(
        video: video,
        message: "auth_to_access_without_preview_callout_text"
      )
    end
  end

  context "when there is no preview available" do
    it "displays the access without preview text" do
      video = build_stubbed(:video)

      render_callout video, signed_out: true

      expect_to_have_callout_content_with(
        video: video,
        message: "auth_to_access_without_preview_callout_text"
      )
    end
  end

  def expect_to_have_callout_content_with(video:, message:)
    expect(rendered).to have_content(I18n.t(message, scope: "videos.show"))
    expect(rendered).to have_css(".access-callout.auth-to-access")
    expect(rendered).to have_auth_to_access_button_for(video)
  end

  def have_auth_to_access_button_for(video)
    have_link(
      I18n.t("videos.show.auth_to_access_button_text"),
      href: video_auth_to_access_path(video)
    )
  end

  def render_callout(video, signed_out: false)
    allow(view).to receive(:signed_out?).and_return(signed_out)
    render template: "videos/_access_callout", locals: {video: video}
  end
end
