require "spec_helper"

module Teams
  describe TeamPlan, type: :model do
    it { should have_many(:checkouts) }
    it { should have_many(:subscriptions) }
    it { should have_many(:teams) }

    it { should validate_presence_of(:sku) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:individual_price) }

    it_behaves_like "a Plan for public listing" do
      def factory_name
        :team_plan
      end
    end

    describe ".instance" do
      context "when an instance already exists" do
        it "returns it" do
          plan = create(:team_plan)
          expect(TeamPlan.instance).to eq plan
        end
      end

      context "when no instance exists" do
        it "creates one and returns it" do
          expect(TeamPlan.instance).to be_a TeamPlan
          expect(TeamPlan.count).to eq 1
        end
      end

      context "when multiple instances already exist" do
        it "returns the first one" do
          plan = create(:team_plan)
          create(:team_plan)
          expect(TeamPlan.instance).to eq plan
        end
      end
    end

    describe "#subscription_interval" do
      it "returns month" do
        expect(team_plan.subscription_interval).to eq "month"
      end
    end

    context "#minimum_quantity" do
      it "is 3" do
        team_plan = TeamPlan.new

        expect(team_plan.minimum_quantity).to eq 3
      end
    end

    describe "#fulfill" do
      it "starts a subscription for a new team" do
        user = build_stubbed(:user)
        user.stubs(:create_purchased_subscription)
        plan = build_stubbed(:team_plan)
        checkout = build_stubbed(:checkout, user: user, subscribeable: plan)
        subscription_fulfillment = stub_subscription_fulfillment(checkout)
        team_fulfillment = stub_team_fulfillment(checkout)

        plan.fulfill(checkout, user)

        expect(subscription_fulfillment).to have_received(:fulfill)
        expect(team_fulfillment).to have_received(:fulfill)
        expect(user).
          to have_received(:create_purchased_subscription).with(plan: plan)
      end

      def stub_team_fulfillment(checkout)
        stub("team-fulfillment", :fulfill).tap do |fulfillment|
          TeamFulfillment.
            stubs(:new).
            with(checkout, checkout.user).
            returns(fulfillment)
        end
      end
    end

    describe "#after_checkout_url" do
      it "returns the edit team path" do
        edit_teams_team_path = "http://example.com/edit_team"
        plan = build_stubbed(:team_plan)
        checkout = build_stubbed(:checkout, subscribeable: plan)
        controller = stub("controller")
        controller.stubs(:edit_teams_team_path).returns(edit_teams_team_path)

        after_checkout_url = plan.after_checkout_url(controller, checkout)

        expect(after_checkout_url).to eq(edit_teams_team_path)
      end
    end

    describe "#has_feature?" do
      it "returns true if the plan has the feature" do
        plan = build_stubbed(:team_plan, :includes_mentor)
        expect(plan.has_feature?(:mentor)).to be true
      end

      it "returns false if the plan does not have the feature" do
        plan = build_stubbed(:team_plan, :no_mentor)
        expect(plan.has_feature?(:mentor)).to be false
      end

      it "raises an exception with an invalid feature name" do
        plan = build_stubbed(:team_plan)
        expect{ plan.has_feature?(:foo) }.to raise_error
      end
    end

    def team_plan
      build(:team_plan)
    end
  end
end
