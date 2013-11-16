require 'spec_helper'

describe RevenueCalculator do
  describe '#projected_monthly_revenue' do
    it 'totals the projected monthly revenue of each plan' do
      individual_plan = stub(projected_monthly_revenue: 20)
      team_plan = stub(projected_monthly_revenue: 40)
      PlanFinder.stubs(all: [individual_plan, team_plan])

      expect(RevenueCalculator.new.projected_monthly_revenue).to eq 60
      expect(individual_plan).to have_received(:projected_monthly_revenue)
      expect(team_plan).to have_received(:projected_monthly_revenue)
    end
  end
end
