require 'spec_helper'

module Teams
  describe TeamPlan, type: :model do
    it { should have_many(:features) }
    it { should have_many(:purchases) }
    it { should have_many(:subscriptions) }
    it { should have_many(:teams) }

    it { should validate_presence_of(:sku) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:individual_price) }

    it_behaves_like 'a Plan for public listing' do
      def factory_name
        :team_plan
      end
    end

    it_behaves_like 'a Plan with queryable features' do
      def factory_name
        :team_plan
      end
    end

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

    context '#minimum_quantity' do
      it 'is 5' do
        team_plan = TeamPlan.new

        expect(team_plan.minimum_quantity).to eq 5
      end
    end

    describe '#fulfill' do
      it 'starts a subscription for a new team' do
        user = build_stubbed(:user)
        purchase = build_stubbed(:purchase, user: user)
        plan = build_stubbed(:team_plan)
        subscription_fulfillment = stub_subscription_fulfillment(purchase)
        team_fulfillment = stub_team_fulfillment(purchase)

        plan.fulfill(purchase, user)

        expect(subscription_fulfillment).to have_received(:fulfill)
        expect(team_fulfillment).to have_received(:fulfill)
      end

      def stub_team_fulfillment(purchase)
        stub('team-fulfillment', :fulfill).tap do |fulfillment|
          TeamFulfillment.
            stubs(:new).
            with(purchase, purchase.user).
            returns(fulfillment)
        end
      end
    end

    describe '#after_purchase_url' do
      it 'returns the edit team path' do
        edit_teams_team_path = 'http://example.com/edit_team'
        plan = build_stubbed(:team_plan)
        purchase = build_stubbed(:purchase, purchaseable: plan)
        controller = stub('controller')
        controller.stubs(:edit_teams_team_path).returns(edit_teams_team_path)

        after_purchase_url = plan.after_purchase_url(controller, purchase)

        expect(after_purchase_url).to eq(edit_teams_team_path)
      end
    end

    describe '#includes_mentor?' do
      context 'when the plan includes mentoring' do
        it 'returns true' do
          plan = team_plan(:with_mentoring)

          result = plan.includes_mentor?

          expect(result).to be_true
        end
      end

      context 'when the plan does not include mentoring' do
        it 'returns false' do
          plan = team_plan

          result = plan.includes_mentor?

          expect(result).to be_false
        end
      end
    end

    describe '#includes_workshops?' do
      context 'when the plan includes workshops' do
        it 'returns true' do
          plan = team_plan(:with_workshops)

          result = plan.includes_workshops?

          expect(result).to be_true
        end
      end

      context 'when the plan does not include workshops' do
        it 'returns false' do
          plan = team_plan

          result = plan.includes_workshops?

          expect(result).to be_false
        end
      end
    end

    def team_plan(options = [])
      create(:team_plan, *options)
    end
  end
end
