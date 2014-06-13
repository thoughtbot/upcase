require 'spec_helper'

describe FeatureQuery do
  describe '#includes_workshops?' do
    context 'when the plan includes workshops' do
      it 'returns true' do
        plan = create(:plan, :with_workshops)

        result = FeatureQuery.new(plan.features).includes_workshops?

        expect(result).to be_true
      end
    end

    context 'when the plan does not include workshops' do
      it 'returns false' do
        plan = build_stubbed(:plan)

        result = FeatureQuery.new(plan.features).includes_workshops?

        expect(result).to be_false
      end
    end
  end

  describe '#includes_mentor?' do
    context 'when the plan includes mentoring' do
      it 'returns true' do
        plan = create(:plan, :with_mentoring)

        result = FeatureQuery.new(plan.features).includes_mentor?

        expect(result).to be_true
      end
    end

    context 'when the plan does not include mentoring' do
      it 'returns false' do
        plan = build_stubbed(:plan)

        result = FeatureQuery.new(plan.features).includes_mentor?

        expect(result).to be_false
      end
    end
  end
end
