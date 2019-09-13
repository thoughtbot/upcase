require "rails_helper"

describe Team do
  it { should belong_to(:owner).class_name(User) }
  it { should have_many(:users).dependent(:nullify) }
  it { should validate_presence_of(:name) }

  describe "#add_user" do
    it "puts the user on the team" do
      team = create(:team)
      user = create(:user)

      team.add_user(user)

      expect(user.reload.team).to eq team
    end

    context "#users_count" do
      it "returns the number of team members" do
        team = build_stubbed(:team)
        create_list(:user, 2, team: team)

        expect(team.users_count).to eq(2)
      end
    end
  end

  describe "#remove_user" do
    it "removes the user from the team" do
      team = create(:team)
      user = create(:user)

      team.remove_user(user)

      expect(user.reload.team).to be_nil
    end
  end
end
