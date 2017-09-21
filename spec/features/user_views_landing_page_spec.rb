require "rails_helper"

feature "User views landing page" do
  context "the user is not logged in" do
    it "displays the basic landing page" do
      visit root_path

      expect(page).to have_content(I18n.t("pages.landing.hero_call_to_action"))
    end
  end

  context "the user is logged in and needs onboarding" do
    it "displays the welcome page" do
      user = create(:subscriber, :with_full_subscription, :needs_onboarding)
      sign_in_as user

      visit root_path

      expect(page).to have_content(I18n.t("pages.welcome.headline"))
    end
  end

  context "the user is logged in and does not needs onboarding" do
    it "displays the welcome page" do
      user = create(:subscriber, :with_full_subscription, :onboarded)
      sign_in_as user

      visit root_path

      expect(page).to have_content(I18n.t("practice.show.trail_description"))
    end
  end
end
