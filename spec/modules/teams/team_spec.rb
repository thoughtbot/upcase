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

    describe "#has_invited_users?" do
      it "returns false when the team has no invitations" do
        team = build(:team, invitations: [])

        expect(team).not_to have_invited_users
      end

      it "returns true when the team has invitations" do
        team = build(:team, invitations: build_list(:invitation, 3))

        expect(team).to have_invited_users
      end
    end

    describe "#invitations_remaining" do
      it "returns the difference between users and max users" do
        team = create(:team, max_users: 5)
        create_list(:user, 3, team: team)

        expect(team.invitations_remaining).to eq 2
      end

      it "never returns negative" do
        team = create(:team, max_users: 2)
        create_list(:user, 4, team: team)

        expect(team.invitations_remaining).to eq 0
      end
    end

    def stub_team_fulfillment(team, user)
      checkout = build_stubbed(:checkout, subscribeable: team.subscription.plan)
      stub_subscription_fulfillment(checkout, user)
    end
  end
end
