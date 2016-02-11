require "rails_helper"

describe "practice/show.html" do
  context "when there are beta offers to display" do
    it "renders the beta offers" do
      stub_user_access
      beta_offer = build_stubbed(:beta_offer, name: "Great beta offer")

      render_show beta_offers: [beta_offer]

      expect(rendered).to have_beta_offers
      expect(rendered).to have_content("Great beta offer")
    end
  end

  context "when there are no beta offers to display" do
    it "doesn't render the beta offers" do
      stub_user_access

      render_show beta_offers: []

      expect(rendered).not_to have_beta_offers
    end
  end

  context "when a user has activity in trails" do
    it "doesn't show 'view completed' link when it has no completed trails" do
      stub_user_access(has_active_subscription: true)

      render_show

      expect(rendered).not_to have_content("View completed trails")
    end
  end

  context "when a user has an active subscription" do
    it "does not render the locked_features partial" do
      stub_user_access(has_active_subscription: true)

      render_show

      expect(rendered).not_to(
        have_content(I18n.t("products.locked_features.why_they_are_locked")),
      )
    end
  end

  context "when a user does not have an active subscription" do
    it "renders locked features partial with all features" do
      stub_user_access(has_active_subscription: false)

      render_show

      expect(rendered).to(
        have_content(I18n.t("products.locked_features.why_they_are_locked")),
      )
    end
  end

  context "for a non-admin user" do
    it "does not render the deck links" do
      stub_user_access(has_active_subscription: true)
      deck = build_stubbed(:deck)

      render_show decks: [deck]

      expect(rendered).not_to have_content(deck.title)
    end
  end

  def practice_stub(options = {})
    defaults = {
      shows: [],
      topics: [],
      beta_offers: [],
      in_progress_trails: [],
      unstarted_trails: [],
      just_finished_trails: [],
      decks: [],
      has_completed_trails?: false
    }
    double("Practice", defaults.merge(options))
  end

  def stub_user_access(has_active_subscription: false)
    user = build_stubbed(:user)
    allow(user).to receive(:has_active_subscription?).
      and_return(has_active_subscription)
    view_stubs(:current_user).and_return(user)
    view_stubs(:current_user_has_access_to?).and_return(false)
  end

  def render_show(options = {})
    assign(:practice, practice_stub(options))
    render template: "practice/show"
  end

  def default_options
    {
      repositories: false,
      forum: false,
      shows: false,
      trails: false
    }
  end

  def have_beta_offers
    have_content("Beta Trails")
  end
end
