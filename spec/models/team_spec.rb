require 'spec_helper'

describe Team do
  it { should belong_to(:subscription) }
  it { should belong_to(:team_plan) }
  it { should have_many(:users).dependent(:nullify) }
  it { should validate_presence_of(:name) }

  describe '#add_user' do
    it "fulfils that user's subscription" do
      team = create(:team)
      user = create(:user, :with_mentor)
      fulfillment = stub_subscription_fulfillment(team.subscription, user)

      team.add_user(user)

      expect(user.reload.team).to eq(team)
      fulfillment.should have_received(:fulfill)
    end
  end

  describe '#remove_user' do
    it "removes that user's subscription" do
      team = create(:team)
      user = create(:user, :with_mentor, team: team)
      fulfillment = stub_subscription_fulfillment(team.subscription, user)

      team.remove_user(user)

      expect(user.reload.team).to be_nil
      fulfillment.should have_received(:remove)
    end
  end

  def stub_subscription_fulfillment(subscription, user)
    purchase = build_stubbed(:purchase)
    subscription.stubs(:purchase).returns(purchase)
    stub('fulfillment', fulfill: true, remove: true).tap do |fulfillment|
      SubscriptionFulfillment.
        stubs(:new).
        with(purchase, user).
        returns(fulfillment)
    end
  end
end
