require 'spec_helper'

describe TotalChurn do
  describe '#current' do
    it 'calculates the total current churn for the given plans' do
      calculated_churn = 28.571428571428573
      first_plan = stub(current_churn: 50, subscription_count: 2)
      second_plan = stub(current_churn: 20, subscription_count: 5)

      total_churn = TotalChurn.new([first_plan, second_plan])

      expect(total_churn.current).to eq calculated_churn
      expect_plan_to_have_received_churn_calculation(first_plan)
      expect_plan_to_have_received_churn_calculation(second_plan)
    end
  end

  def expect_plan_to_have_received_churn_calculation(plan)
    expect(plan).to have_received(:current_churn)
    expect(plan).to have_received(:subscription_count).times(2)
  end
end
