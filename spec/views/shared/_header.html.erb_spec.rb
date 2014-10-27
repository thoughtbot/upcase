require "rails_helper"

describe "shared/_header.html.erb" do
  include AnalyticsHelper

  let(:call_to_action_label) { "Get two months free" }

  context "when user is the subscription owner" do
    it "shows an annual upsell link" do
      render(
        current_user_has_active_subscription: true,
        current_user_is_subscription_owner: true,
        signed_in: true
      )

      expect(rendered).to have_content(call_to_action_label)
    end
  end

  context "when user is not the subscription owner" do
    it "does not show an annual upsell link" do
      render(
        current_user_has_active_subscription: true,
        current_user_is_subscription_owner: false,
        signed_in: true
      )

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

      render(
        current_user_has_active_subscription: true,
        current_user_has_monthly_subscription: false,
        current_user_is_subscription_owner: true,
        signed_in: true
      )

      expect(rendered).not_to have_content(call_to_action_label)
    end
  end

  context "when the user isn't signed in" do
    it "shows a plans and pricing link" do
      render(signed_in: false)

      expect(rendered).to have_content(I18n.t("subscriptions.join_cta"))
    end
  end

  context "when the user isn't subscribed" do
    it "shows a membership link" do
      render(
        signed_in: true,
        current_user_has_active_subscription: false
      )

      expect(rendered).to have_css("a[href='#{subscribe_path}']")
    end
  end

  context "when the user has a subscription" do
    it "does not show a membership link" do
      render(
        signed_in: true,
        current_user_has_active_subscription: true
      )

      expect(rendered).not_to have_css("a[href='#{subscribe_path}']")
    end
  end

  def render(
    current_user_has_active_subscription: true,
    current_user_has_monthly_subscription: true,
    current_user_is_subscription_owner: true,
    masquerading: false,
    signed_in: true
  )
    view_stubs(
      current_user_has_active_subscription?:
        current_user_has_active_subscription
    )
    view_stubs(
      current_user_has_monthly_subscription?:
        current_user_has_monthly_subscription
    )
    view_stubs(
      current_user_is_subscription_owner?:
        current_user_is_subscription_owner
    )
    view_stubs(masquerading?: masquerading)
    view_stubs(signed_in?: signed_in)
    super()
  end
end
