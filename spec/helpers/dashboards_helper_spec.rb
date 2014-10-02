require "rails_helper"

describe DashboardsHelper, "#subscribe_or_upgrade_link" do
  before do
    @virtual_path = "dashboards.show"
    helper.instance_variable_set(:@virtual_path, @virtual_path)
  end

  context "when the user has no active subscription" do
    it "shows a 'subscribe' link" do
      stub_inactive_subscription

      result = helper.subscribe_or_upgrade_link

      expect(result).to match(t(".locked_features.subscribe_link"))
      expect(result).to match(new_subscription_path)
    end
  end

  context "when the user has an active subscription" do
    it "shows an 'upgrade' link" do
      stub_active_subscription

      result = helper.subscribe_or_upgrade_link

      expect(result).to match(t(".locked_features.upgrade_link"))
      expect(result).to match(edit_subscription_path)
    end
  end

  def stub_active_subscription
    stub_subscription(true)
  end

  def stub_inactive_subscription
    stub_subscription(false)
  end

  def stub_subscription(result)
    Mocha::Configuration.allow(:stubbing_non_existent_method) do
      helper.stubs(:current_user_has_active_subscription?).returns(result)
    end
  end
end
