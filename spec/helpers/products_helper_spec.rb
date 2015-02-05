require "rails_helper"

describe ProductsHelper do
  describe "#completeable_link" do
    context "with access to exercises" do
      it "renders a link to the exercise url" do
        stub_access(exercises: true)
        url = "http://example.com/some/exercise"

        result = helper.completeable_link(url, class: "amazing") { "text" }

        expect(result).to have_css("a.amazing:contains('text')[href='#{url}']")
      end
    end

    context "without access to exercises" do
      it "renders a link to the change plan page" do
        stub_access(exercises: false)
        provided_url = "http://example.com"
        expected_url = edit_subscription_path

        result = helper.
          completeable_link(provided_url, class: "amazing") { "text" }

        expect(result).
          to have_css("a.amazing:contains('text')[href='#{expected_url}']")
      end
    end
  end

  def stub_access(features)
    features.each do |name, access|
      allow(helper).to receive(:current_user_has_access_to?).with(name).
        and_return(access)
    end
  end
end
