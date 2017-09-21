require "rails_helper"

describe "layouts/_header_marketing_links.html.erb" do
  include PlansHelper

  before do
    allow(Show).to receive(:the_weekly_iteration).and_return("")
  end

  context "when not on the teams page" do
    it "renders a link to the teams page" do
      render_header(team_page: false)

      expect(rendered).to have_link(
        t("shared.header.teams"),
        href: teams_path,
      )
    end
  end

  context "when on the teams page" do
    it "doesn't renders a link to the teams page" do
      render_header(team_page: true)

      expect(rendered).not_to have_link(
        t("shared.header.teams"),
        href: teams_path,
      )
    end
  end

  context "where there is content_for `header_cta_link`" do
    it "shows the content in the CTA button" do
      render_header(header_cta_link: "result")

      expect(rendered).to have_css(
        "#site_nav_call_to_action",
        text: "result",
      )
    end
  end

  context "where there isn't content_for `header_cta_link`" do
    it "renders a CTA link to the professional_checkout" do
      render_header(header_cta_link: nil)

      expect(rendered).to have_link(
        t("subscriptions.join_cta"),
        href: professional_checkout_path,
      )
    end
  end

  context "when signed_out and on the signing path" do
    it "renders the sign_in link" do
      render_header(signed_out: true, not_on_signin_path: false)

      expect(rendered).not_to have_link(
        t("shared.header.sign_in"),
        href: sign_in_path,
      )
    end
  end

  context "when signed_out and not on the signing path" do
    context "on a sales landing page" do
      it "renders the plain sign_in link" do
        render_header(signed_out: true, landing_page: true)

        expect(rendered).to have_link(
          t("shared.header.sign_in"),
          href: sign_in_path,
        )
      end
    end

    context "when on a non-sales page" do
      it "renders the sign_in link with return_to provided for current_path" do
        render_header(signed_out: true, landing_page: false)

        expect(rendered).to have_link(
          t("shared.header.sign_in"),
          href: sign_in_path_with_return_to,
        )
      end
    end
  end

  context "when signed_in" do
    it "doesn't render the sign_in link" do
      render_header(signed_out: false)

      expect(rendered).not_to have_link(
        t("shared.header.sign_in"),
        href: sign_in_path,
      )
    end
  end

  def render_header(
    signed_out: false,
    team_page: false,
    header_cta_link: nil,
    landing_page: false,
    not_on_signin_path: true
  )
    allow(view).to receive(:signed_out?).and_return(signed_out)
    allow(view).to receive(:team_page?).and_return(team_page)
    allow(view).to receive(:landing_page?).and_return(landing_page)
    allow(view).to receive(:not_on_signin_path?).and_return(not_on_signin_path)

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

  def sign_in_path_with_return_to
    sign_in_path(return_to: "")
  end
end
