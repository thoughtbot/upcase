require 'spec_helper'

module Teams
  describe Team, type: :model do
    it { should belong_to(:subscription) }
    it { should belong_to(:team_plan) }
    it { should have_many(:users).dependent(:nullify) }
    it { should validate_presence_of(:name) }

    describe '#add_user' do
      it "fulfils that user's subscription" do
        team = create(:team)
        user = create(:user, :with_mentor)
        fulfillment = stub_team_fulfillment(team, user)

        team.add_user(user)

        expect(user.reload.team).to eq(team)
        expect(fulfillment).to have_received(:fulfill)
      end
    end

    describe '#remove_user' do
      it "removes that user's subscription" do
        team = create(:team)
        user = create(:user, :with_mentor)
        fulfillment = stub_team_fulfillment(team, user)

        team.remove_user(user)

        expect(user.reload.team).to be_nil
        expect(fulfillment).to have_received(:remove)
      end
    end

    describe '#has_users_remaining?' do
      it 'returns true when the number of users is less than the max' do
        expect(team_with_user_counts(actual: 1, max: 2)).
          to have_users_remaining
      end

      it 'returns false when the number of users is equal to the max' do
        expect(team_with_user_counts(actual: 2, max: 2)).
          not_to have_users_remaining
      end

      it 'returns false when the number of users is greater than the max' do
        expect(team_with_user_counts(actual: 3, max: 2)).
          not_to have_users_remaining
      end

      def team_with_user_counts(counts)
        users = create_list(:user, counts[:actual])
        create(:team, max_users: counts[:max], users: users)
      end
    end

    def stub_team_fulfillment(team, user)
      purchase = build_stubbed(:purchase)
      team.subscription.stubs(:purchase).returns(purchase)
      stub_subscription_fulfillment(purchase, user)
    end
  end
end
