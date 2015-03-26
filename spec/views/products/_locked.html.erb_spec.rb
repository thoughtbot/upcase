require "rails_helper"

describe "products/_locked" do
  context "when the user is signed in" do
    it "encourages them to upgrade" do
      stub_signed_in_with(build_stubbed(:user))

      render partial: "products/locked"

      expect(rendered).to include("Get access by upgrading")
    end
  end

  context "when the user is not signed in" do
    it "encourages them to join" do
      stub_signed_in_with(nil)

      render partial: "products/locked"

      expect(rendered).to include("Get access by joining Upcase")
      expect(rendered).to have_css("a[href='#{join_path}']")
    end
  end

  def stub_signed_in_with(value)
    view_stubs(:signed_in?).and_return(value)
  end
end
