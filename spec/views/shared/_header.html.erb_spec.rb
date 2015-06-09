require "rails_helper"

describe "shared/_header.html.erb" do
  include AnalyticsHelper
  include Gravatarify::Helper

  let(:call_to_action_label) { "Get two months free" }

  it "renders the user's avatar" do
    email = generate(:email)

    render(signed_in: true, current_user_email: email)

    expect(rendered).to have_css(<<-CSS.strip)
      img[src='#{gravatar_url(email, size: "30")}']
    CSS
  end

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
      view_stub_with_return(masquerading?: false)
      view_stub_with_return(signed_in?: true)
      view_stub_with_return(current_user_has_active_subscription?: true)
      view_stub_with_return(current_user_is_subscription_owner?: true)
      view_stub_with_return(current_user_is_eligible_for_annual_upgrade?: false)

      render(
        current_user_has_active_subscription: true,
        current_user_is_eligible_for_annual_upgrade: false,
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

      expect(rendered).to have_css("a[href='#{new_subscription_path}']")
    end
  end

  context "when the user has a subscription" do
    it "does not show a membership link" do
      render(
        signed_in: true,
        current_user_has_active_subscription: true
      )

      expect(rendered).not_to have_css("a[href='#{new_subscription_path}']")
    end
  end

  context "in welcome mode" do
    it "shows only a help link" do
      render(onboarded: false)

      expect(rendered).not_to have_practice_link
      expect(rendered).to have_link("Help", welcome_path)
    end
  end

  def have_practice_link
    have_link(I18n.t("shared.header.practice"), practice_path)
  end

  def render(
    current_user_email: "user@example.com",
    current_user_has_active_subscription: true,
    current_user_is_eligible_for_annual_upgrade: true,
    current_user_is_subscription_owner: true,
    masquerading: false,
    signed_in: true,
    onboarded: true
  )
    view_stub_with_return(
      onboarding_policy:
      double(:onboarding_policy, onboarded?: onboarded)
    )

    view_stub_with_return(
      current_user_has_active_subscription?:
        current_user_has_active_subscription
    )
    view_stub_with_return(
      current_user_is_eligible_for_annual_upgrade?:
        current_user_is_eligible_for_annual_upgrade
    )
    view_stub_with_return(
      current_user_is_subscription_owner?:
        current_user_is_subscription_owner
    )
    view_stub_with_return(masquerading?: masquerading)
    view_stub_with_return(signed_in?: signed_in)
    view_stub_with_return(
      current_user: double(
        "user",
        email: current_user_email,
        has_access_to?: false
      )
    )
    super()
  end
end
