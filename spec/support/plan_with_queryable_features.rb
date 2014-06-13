shared_examples 'a Plan with queryable features' do
  describe '#includes_mentor?' do
    context 'when the plan includes mentoring' do
      it 'returns true' do
        plan = build_plan
        stub_feature(plan, :includes_mentor?, true)

        result = plan.includes_mentor?

        expect(result).to be_true
      end
    end

    context 'when the plan does not include mentoring' do
      it 'returns false' do
        plan = build_plan
        stub_feature(plan, :includes_mentor?, false)

        result = plan.includes_mentor?

        expect(result).to be_false
      end
    end

  end

  describe '#includes_workshops?' do
    context 'when the plan includes workshops' do
      it 'returns true' do
        plan = build_plan
        stub_feature(plan, :includes_workshops?, true)

        result = plan.includes_workshops?

        expect(result).to be_true
      end
    end

    context 'when the plan does not include workshops' do
      it 'returns false' do
        plan = build_plan
        stub_feature(plan, :includes_workshops?, false)

        result = plan.includes_workshops?

        expect(result).to be_false
      end
    end
  end

  def build_plan
    build_stubbed(factory_name)
  end

  def stub_feature(plan, feature, return_value)
    query = stub('query')
    query.stubs(feature).returns(return_value)
    FeatureQuery.stubs(:new).with(plan.features).returns(query)
  end

  def factory_name
    described_class.name.underscore.to_sym
  end
end
