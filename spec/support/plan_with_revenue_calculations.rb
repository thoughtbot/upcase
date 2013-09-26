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

  describe '#subscription_count_30_days_ago' do
    it 'returns 0 when the plan has a single active, paid subscription created less than 30 days ago' do
      plan = create_plan
      create(:active_subscription, plan: plan, paid: true, created_at: 29.days.ago)

      expect(plan.subscription_count_30_days_ago).to eq 0
    end

    it 'returns 1 when the plan has a single active, paid subscription created more than 30 days ago' do
      plan = create_plan
      create(:active_subscription, plan: plan, paid: true, created_at: 31.days.ago)

      expect(plan.subscription_count_30_days_ago).to eq 1
    end
  end

  describe '#current_churn' do
    context 'the plan has a single active, paid subscription that canceled yesterday' do
      it 'returns 100' do
        plan = create_plan
        create(
          :inactive_subscription,
          plan: plan,
          paid: true,
          created_at: 31.days.ago,
          deactivated_on: 1.day.ago
        )

        expect(plan.current_churn).to eq 100
      end
    end

    context 'the plan has a two active, paid subscriptions and one cancelation yesterday' do
      it 'returns 50' do
        plan = create_plan
        create(
          :inactive_subscription,
          plan: plan,
          paid: true,
          created_at: 31.days.ago,
          deactivated_on: 1.day.ago
        )
        create(
          :active_subscription,
          plan: plan,
          paid: true,
          created_at: 31.days.ago
        )

        expect(plan.current_churn).to eq 50
      end
    end
  end

  describe '#current_ltv' do
    context 'the plan has a single active, paid subscription that canceled yesterday' do
      it 'returns the plan price' do
        plan = create_plan
        create(
          :inactive_subscription,
          plan: plan,
          paid: true,
          created_at: 31.days.ago,
          deactivated_on: 1.day.ago
        )

        expect(plan.current_ltv).to eq plan.individual_price
      end
    end

    context 'the plan has a two active, paid subscription and one cancelation yesterday' do
      it 'returns twice the plan price' do
        plan = create_plan
        create(
          :inactive_subscription,
          plan: plan,
          paid: true,
          created_at: 31.days.ago,
          deactivated_on: 1.day.ago
        )
        create(
          :active_subscription,
          plan: plan,
          paid: true,
          created_at: 31.days.ago
        )

        expect(plan.current_ltv).to eq (plan.individual_price * 2)
      end
    end
  end

  def create_plan
    create(factory_name)
  end

  def factory_name
    described_class.name.underscore.to_sym
  end
end
