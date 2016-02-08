require "rails_helper"

describe "layouts/_signed_out_header.html.erb" do
  include PlansHelper

  context "when not on the teams page" do
    it "renders a link to the teams page" do
      render_header(team_page: false)

      expect(rendered).to have_link(
        t("shared.header.teams"),
        team_checkout_path,
      )
    end
  end

  context "when on the teams page" do
    it "doesn't renders a link to the teams page" do
      render_header(team_page: true)

      expect(rendered).not_to have_link(
        t("shared.header.teams"),
        team_checkout_path,
      )
    end
  end

  context "where there is content_for `header_cta_link`" do
    it "shows the content in the CTA button" do
      render_header(header_cta_link: "result")

      expect(rendered).to have_css(
        ".header-cta",
        text: "result",
      )
    end
  end

  context "where there isn't content_for `header_cta_link`" do
    it "renders a CTA link to the professional_checkout" do
      render_header(header_cta_link: nil)

      expect(rendered).to have_link(
        t("subscriptions.join_cta"),
        professional_checkout_path,
      )
    end
  end

  context "when signed_out" do
    it "renders the sign_in link" do
      render_header(signed_out: true)

      expect(rendered).to have_link(
        t("shared.header.sign_in"),
        sign_in_path,
      )
    end
  end

  context "when signed_in" do
    it "doesn't render the sign_in link" do
      render_header(signed_out: false)

      expect(rendered).not_to have_link(
        t("shared.header.sign_in"),
        sign_in_path,
      )
    end
  end

  def render_header(signed_out: false, team_page: false, header_cta_link: nil)
    allow(view).to receive(:signed_out?).and_return(signed_out)
    allow(view).to receive(:team_page?).and_return(team_page)

    if header_cta_link
      allow(view).to receive(:content_for?).
        with(:header_cta_link).
        and_return(true)
      allow(view).to receive(:content_for).
        with(:header_cta_link).
        and_return(header_cta_link)
    end

    render
  end
end
