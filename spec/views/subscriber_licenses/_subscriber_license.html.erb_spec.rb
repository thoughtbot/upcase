require "spec_helper"

describe "subscriber_licenses/_subscriber_license.html.erb" do
  context "with a plan that has includes the purchaseable" do
    it "renders a free message" do
      stub_product_and_subscriber_license
      stub_plan_to_include_purchaseable

      render "subscriber_licenses/subscriber_license"

      expect(rendered).to include(
        html_escape(t("products.show.free_to_subscribers"))
      )
    end
  end

  context "with a plan that does not have access to the purchaseable" do
    it "does not render a free message" do
      stub_product_and_subscriber_license
      stub_plan_to_not_include_purchaseable

      render "subscriber_licenses/subscriber_license"

      expect(rendered).not_to include(
        html_escape(t("products.show.free_to_subscribers"))
      )
    end
  end

  def stub_plan_to_include_purchaseable
    view_stubs(:included_in_current_users_plan?).returns(true)
  end

  def stub_plan_to_not_include_purchaseable
    view_stubs(:included_in_current_users_plan?).returns(false)
  end

  def stub_product_and_subscriber_license
    view_stubs(:product).returns(build_stubbed(:product))
    view_stubs(:subscriber_license).returns(SubscriberLicense.new({}))
  end
end
