require "rails_helper"

describe "shared/_header.html.erb" do
  include AnalyticsHelper

  let(:call_to_action_label) { "Get two months free" }

  context "when user is the subscription owner" do
    it "shows an annual upsell link" do
      view_stubs(masquerading?: false)
      view_stubs(signed_in?: true)
      view_stubs(current_user_has_active_subscription?: true)
      view_stubs(current_user_is_subscription_owner?: true)
      view_stubs(current_user_has_monthly_subscription?: true)

      render

      expect(rendered).to have_content(call_to_action_label)
    end
  end

  context "when user is not the subscription owner" do
    it "does not show an annual upsell link" do
      view_stubs(masquerading?: false)
      view_stubs(signed_in?: true)
      view_stubs(current_user_has_active_subscription?: true)
      view_stubs(current_user_is_subscription_owner?: false)

      render

      expect(rendered).not_to have_content(call_to_action_label)
    end
  end

  context "when user is the subscription owner of an annual plan" do
    it "does not show an annual upsell link" do
      view_stubs(masquerading?: false)
      view_stubs(signed_in?: true)
      view_stubs(current_user_has_active_subscription?: true)
      view_stubs(current_user_is_subscription_owner?: true)
      view_stubs(current_user_has_monthly_subscription?: false)

      render

      expect(rendered).not_to have_content(call_to_action_label)
    end
  end
end
