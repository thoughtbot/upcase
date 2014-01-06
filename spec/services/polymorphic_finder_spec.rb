require 'spec_helper'

describe PolymorphicFinder do
  describe '#find' do
    it 'finds the first given finder when present' do
      individual_plan = create(:individual_plan, sku: 'abc')

      result = PolymorphicFinder.
        finding(IndividualPlan, :sku, [:individual_plan_id]).
        find(individual_plan_id: 'abc')

      expect(result).to eq(individual_plan)
    end

    it 'finds the first of several possible params' do
      screencast = create(:screencast)

      result = PolymorphicFinder.
        finding(Product, :id, [:book_id, :screencast_id, :product_id]).
        find(screencast_id: screencast.to_param)

      expect(result).to eq(screencast)
    end

    it 'cascades when the first finder is not present' do
      create(:individual_plan, sku: 'abc')
      team_plan = create(:team_plan, sku: 'def')

      result = PolymorphicFinder.
        finding(IndividualPlan, :sku, [:individual_plan_id]).
        finding(TeamPlan, :sku, [:team_plan_id]).
        find(team_plan_id: 'def')

      expect(result).to eq(team_plan)
    end

    it 'raises an exception for an unknown ID' do
      create(:individual_plan, sku: 'abc')

      finder = PolymorphicFinder.
        finding(IndividualPlan, :sku, [:individual_plan_id])

      expect { finder.find(individual_plan_id: 'def') }.
        to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises an exception without any ID' do
      params = { 'key' => 'value' }
      finder = PolymorphicFinder.
        finding(IndividualPlan, :sku, [:individual_plan_id])

      expect { finder.find(params) }.
        to raise_error(ActiveRecord::RecordNotFound, /#{Regexp.escape(params.inspect)}/)
    end
  end
end
