require 'rails_helper'

describe PlanFinder, type: :model do
  describe '.where' do
    it 'finds IndividualPlans by sku' do
      individual_plan = create(:individual_plan, sku: 'individual_plan')

      expect(PlanFinder.where(sku: 'individual_plan')).to eq [individual_plan]
    end

    it 'finds TeamPlans by sku' do
      team_plan = create(:team_plan, sku: 'team_plan')

      expect(PlanFinder.where(sku: 'team_plan')).to eq [team_plan]
    end
  end

  describe '.all' do
    it 'returns all IndividualPlans' do
      plan = create(:individual_plan)

      expect(PlanFinder.all).to include plan
    end

    it 'returns all TeamPlans' do
      plan = create(:team_plan)

      expect(PlanFinder.all).to include plan
    end
  end
end
