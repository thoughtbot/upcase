require "rails_helper"

describe PolymorphicFinder do
  describe '#find' do
    it 'finds the first given finder when present' do
      plan = create(:plan, sku: 'abc')

      result = PolymorphicFinder.
        finding(Plan, :sku, [:plan_id]).
        find(plan_id: 'abc')

      expect(result).to eq(plan)
    end

    it 'finds the first of several possible params' do
      screencast = create(:screencast)

      result = PolymorphicFinder.
        finding(Product, :slug, [:book_id, :screencast_id, :product_id]).
        find(screencast_id: screencast.to_param)

      expect(result).to eq(screencast)
    end

    it 'cascades when the first finder is not present' do
      create(:plan, sku: 'abc')
      team_plan = create(:plan, :team, sku: 'def')

      result = PolymorphicFinder.
        finding(Plan, :sku, [:plan_id]).
        finding(Plan, :sku, [:team_plan_id]).
        find(team_plan_id: 'def')

      expect(result).to eq(team_plan)
    end

    it 'raises an exception for an unknown ID' do
      create(:plan, sku: 'abc')

      finder = PolymorphicFinder.
        finding(Plan, :sku, [:plan_id])

      expect { finder.find(plan_id: 'def') }.
        to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises an exception without any ID' do
      params = { 'key' => 'value' }
      finder = PolymorphicFinder.
        finding(Plan, :sku, [:plan_id])

      expect { finder.find(params) }.
        to raise_error(ActiveRecord::RecordNotFound, /#{Regexp.escape(params.inspect)}/)
    end
  end
end
