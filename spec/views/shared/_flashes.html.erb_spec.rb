require "rails_helper"

describe "shared/_flashes.html.erb" do
  context "when signed out" do
    before do
      view_stub_with_return(
        flash: {
          "notice" => "Thank you",
          "purchase_amount" => 29
        }
      )
    end

    it "loads the Segment.io JavaScript library" do
      render

      expect(rendered).to include("Thank you")
      expect(rendered).not_to include("29")
    end
  end
end
