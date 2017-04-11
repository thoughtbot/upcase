require "rails_helper"

describe "trails/_completeablel_preview.html" do
  include Rails.application.routes.url_helpers
  include TrailHelpers

  context "with access to the completeable" do
    it "links to the completeable page" do
      stub_access true
      completeable = build_completeable_with_progress

      render "trails/completeable_preview", completeable: completeable

      expect(rendered).to have_link_to(url_for(completeable))
      expect(rendered).not_to have_get_access_by_joining_link
    end
  end

  context "without access to a subscription-only completeable" do
    it "links to the join page" do
      stub_access false
      completeable = build_completeable_with_progress

      render "trails/completeable_preview", completeable: completeable

      expect(rendered).to have_get_access_by_joining_link
      expect(rendered).not_to have_link_to(url_for(completeable))
    end
  end

  def stub_access(result)
    view_stubs(:current_user_has_access_to?).and_return(result)
  end

  def have_get_access_by_joining_link
    have_link I18n.t("products.locked.get_access_by_joining"), href: sign_up_path
  end
end
