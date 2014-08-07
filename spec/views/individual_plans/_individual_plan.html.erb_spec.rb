require "spec_helper"

describe "individual_plans/_individual_plan.html", :type => :view do
  context "grid partial" do
    it "renders the grid partial matching the plan" do
      prime_29 = build_plan
      stub_view

      render_plan(prime_29)

      expect(view).to render_template("individual_plans/_prime_29")
    end
  end

  context "popular plan" do
    it "adds the 'popular' class to the plan designated as popular" do
      plan = build_plan
      plan.stubs(popular?: true)
      stub_view

      render_plan(plan)

      expect(rendered).to have_css(".popular")
    end

    it "does not add the 'popular' class to plans not designated as popular" do
      plan = build_plan
      stub_view

      render_plan(plan)

      expect(rendered).not_to have_css(".popular")
    end
  end

  context "plan link" do
    it "links to create a new plan if the user does not have a subscription" do
      plan = build_plan
      stub_view

      render_plan(plan)

      link = new_checkout_path(plan)
      expect(rendered).to have_css("a[href='#{link}']")
    end

    it "links to change existing plan when user has a subscription" do
      plan = build_plan
      user = stub("user", plan: build_stubbed(:plan))
      view_stubs(:current_user).returns(user)
      stub_view(active_subscription: true)

      render_plan(plan)

      link = subscription_path(plan_id: plan.sku)
      expect(rendered).to have_css("a[href='#{link}']")
    end
  end

  def stub_view(active_subscription: false)
    view_stubs(:current_user_has_active_subscription?).
      returns(active_subscription)
  end

  def build_plan
    build_stubbed(:plan, sku: "prime-29").tap do |plan|
      plan.stubs(popular?: false)
    end
  end

  def render_plan(plan)
    render "individual_plans/individual_plan", individual_plan: plan
  end
end
