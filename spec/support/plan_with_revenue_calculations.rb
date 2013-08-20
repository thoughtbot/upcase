shared_examples 'a Plan with countable subscriptions' do
  describe '#subscription_count' do
    it 'returns 0 when the plan has no subscriptions' do
      plan = create_plan

      expect(plan.subscription_count).to eq 0
    end

    it 'returns 1 when the plan has a single active subscription that is paid' do
      plan = create_plan
      create(:active_subscription, plan: plan, paid: true)

      expect(plan.subscription_count).to eq 1
    end

    it 'returns 0 when the plan has an active subscription that is unpaid' do
      plan = create_plan
      create(:active_subscription, plan: plan, paid: false)

      expect(plan.subscription_count).to eq 0
    end

    it 'returns 0 when the plan has only an inactive subscription' do
      plan = create_plan
      create(:inactive_subscription, plan: plan)

      expect(plan.subscription_count).to eq 0
    end
  end

  def create_plan
    create(factory_name)
  end

  def factory_name
    described_class.name.underscore.to_sym
  end
end
