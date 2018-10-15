require "rails_helper"

feature "User views landing page" do
  context "the user is not logged in" do
    it "displays the basic landing page" do
      visit root_path

      expect(page).to have_content(I18n.t("pages.landing.hero_call_to_action"))
    end
  end
end
