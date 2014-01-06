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
      fulfillment = stub_team_fulfillment(team, user)

      team.add_user(user)

      expect(user.reload.team).to eq(team)
      fulfillment.should have_received(:fulfill)
    end
  end

  describe '#remove_user' do
    it "removes that user's subscription" do
      team = create(:team)
      user = create(:user, :with_mentor)
      fulfillment = stub_team_fulfillment(team, user)

      team.remove_user(user)

      expect(user.reload.team).to be_nil
      fulfillment.should have_received(:remove)
    end
  end

  def stub_team_fulfillment(team, user)
    purchase = build_stubbed(:purchase)
    team.subscription.stubs(:purchase).returns(purchase)
    stub_subscription_fulfillment(purchase, user)
  end
end
