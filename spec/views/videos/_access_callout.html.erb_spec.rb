require "rails_helper"

describe "videos/_access_callout" do
  context "when the user is a guest" do
    context "and the video is a free sample" do
      it "displays an auth to access message and button for the video" do
        video = build_stubbed(:video, :free_sample)

        render_callout video, signed_out: true

        expect(rendered).to have_css ".access-callout.auth-to-access"
        expect(rendered).to have_auth_to_access_link_for(video)
      end
    end

    context "when the video is not a free sample" do
      it "displays the 'preview' message and CTA" do
        video = build_stubbed(:video)

        render_callout video, signed_out: true

        expect(rendered).to have_css ".access-callout.subscription-required"
        expect(rendered).to have_subscribe_cta
      end
    end
  end

  context "when the user is a sampler" do
    context "and the video is a free sample" do
      it "displays a subscribe CTA about viewing all the videos" do
        video = build_stubbed(:video, :free_sample)

        render_callout video, signed_out: false

        expect(rendered).to have_css ".access-callout.subscription-required"
        expect(rendered).to have_content(
          I18n.t("videos.show.access_callout_for_sample_text"),
        )
        expect(rendered).to have_subscribe_cta
      end
    end

    context "and the video is not a free sample" do
      it "displays the 'preview' message and CTA" do
        video = build_stubbed(:video)

        render_callout video, signed_out: false

        expect(rendered).to have_css ".access-callout.subscription-required"
        expect(rendered).to have_content(
          I18n.t("videos.show.access_callout_for_preview_text"),
        )
        expect(rendered).to have_subscribe_cta
      end
    end
  end

  def have_auth_to_access_link_for(video)
    have_link(
      I18n.t("videos.show.auth_to_access_button_text"),
      href: video_auth_to_access_path(video),
    )
  end

  def render_callout(video, signed_out: false)
    allow(view).to receive(:signed_out?).and_return(signed_out)
    render template: "videos/_access_callout", locals: { video: video }
  end

  def have_subscribe_cta
    have_link(
      "Subscribe Now",
      href: new_checkout_path(:professional),
    )
  end
end
