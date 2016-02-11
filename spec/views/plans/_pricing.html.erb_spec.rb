require "rails_helper"

describe "plans/_pricing.html" do
  context "header" do
    it "shows short descriptions for each plan" do
      the_weekly_iteration = build_stubbed(:plan, sku: Plan::THE_WEEKLY_ITERATION_SKU)
      professional = build_stubbed(:plan, sku: "professional")

      render_pricing_with_plans [the_weekly_iteration, professional]

      expect(rendered).to have_content(the_weekly_iteration.short_description)
      expect(rendered).to have_content(professional.short_description)
    end

    it "adds the 'professional' class to the plan designated as professional" do
      the_weekly_iteration = build_stubbed(:plan, sku: Plan::THE_WEEKLY_ITERATION_SKU)
      allow(the_weekly_iteration).to receive(:professional?).and_return(true)

      render_pricing_with_plans [the_weekly_iteration]

      expect(rendered).to have_css(".professional")
    end
  end

  def render_pricing_with_plans(plans)
    user = double(:current_user, has_active_subscription?: false)
    view_stubs(:current_user).and_return(user)
    render "plans/pricing", plans: plans
  end
end
