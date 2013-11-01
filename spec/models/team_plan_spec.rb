require 'spec_helper'

describe TeamPlan do
  it { should have_many(:purchases) }
  it { should have_many(:subscriptions) }
  it { should have_many(:teams) }

  it { should validate_presence_of(:sku) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:individual_price) }

  it_behaves_like 'a Plan with countable subscriptions'
  it_behaves_like 'a Plan for public listing'

  describe '.instance' do
    context 'when an instance already exists' do
      it 'returns it' do
        plan = create(:team_plan)
        expect(TeamPlan.instance).to eq plan
      end
    end

    context 'when no instance exists' do
      it 'creates one and returns it' do
        expect(TeamPlan.instance).to be_a TeamPlan
        expect(TeamPlan.count).to eq 1
      end
    end

    context 'when multiple instances already exist' do
      it 'returns the first one' do
        plan = create(:team_plan)
        create(:team_plan)
        expect(TeamPlan.instance).to eq plan
      end
    end
  end

  describe '#subscription?' do
    it 'returns true' do
      expect(team_plan.subscription?).to be_true
    end
  end

  describe '#fulfillment_method' do
    it 'returns the fulfillment method' do
      expect(team_plan.fulfillment_method).to eq 'subscription'
    end
  end

  describe '#fulfilled_with_github?' do
    it 'returns false' do
      expect(team_plan.fulfilled_with_github?).to be_false
    end
  end

  describe '#subscription_interval' do
    it 'returns month' do
      expect(team_plan.subscription_interval).to eq 'month'
    end
  end

  describe '#announcement' do
    it 'returns empty string' do
      expect(team_plan.announcement).to be_blank
    end
  end

  describe '#projected_monthly_revenue' do
    context 'when there are no Teams' do
      it 'returns 0' do
        expect(team_plan.projected_monthly_revenue).to eq 0
      end
    end

    context 'when there are Teams' do
      it 'returns the number of Teams multiplied by the individual price' do
        team_plan = create(:team_plan)
        create(:team, team_plan: team_plan)
        create(:team, team_plan: team_plan)

        expected_value = team_plan.individual_price * 2
        expect(team_plan.projected_monthly_revenue).to eq expected_value
      end
    end
  end

  def team_plan
    build(:team_plan)
  end
end
