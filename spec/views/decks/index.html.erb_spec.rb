require "rails_helper"

describe "decks/index.html.erb" do
  context "when the current_user is a subscriber" do
    it "doesn't render a cta" do
      allow(view).to receive(:signed_in?).and_return(true)
      stub_translations
      assign(:decks, build_stubbed_list(:deck, 2))

      render template: "decks/index.html.erb"

      expect(rendered).not_to have_css("[data-role='subscribe_cta']")
    end
  end

  def stub_translations
    allow(view).to receive(:t).and_return("")
  end
end
