require "spec_helper"

describe "subscriptions/_pricing.html", type: :view do
  context "header" do
    it "shows short descriptions for each plan" do
      prime_29 = build_stubbed(:plan, sku: "prime-29")
      prime_49 = build_stubbed(:plan, sku: "prime-49")

      render_pricing_with_plans [prime_29, prime_49]

      expect(rendered).to have_content(prime_29.short_description)
      expect(rendered).to have_content(prime_49.short_description)
    end

    it "adds the 'popular' class to the plan designated as popular" do
      prime_29 = build_stubbed(:plan, sku: "prime-29")
      prime_29.stubs(:popular?).returns(true)

      render_pricing_with_plans [prime_29]

      expect(rendered).to have_css(".popular")
    end
  end

  def render_pricing_with_plans(plans)
    view_stubs(:current_user_has_active_subscription?).returns(false)
    render "subscriptions/pricing", plans: plans
  end
end
