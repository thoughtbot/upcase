require "rails_helper"

describe User do
  context "associations" do
    it { should belong_to(:team).optional }
    it { should have_many(:attempts).dependent(:destroy) }
    it { should have_many(:statuses).dependent(:destroy) }
  end

  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:github_username) }

    context "uniqueness" do
      before { create(:user) }

      it { should validate_uniqueness_of(:github_username) }
    end
  end

  context "callbacks" do
    it "identifies the user with analytics after saving" do
      user = build(:user)
      analytics_stub = stub_analytics_for(user)

      user.save

      expect(analytics_stub).to have_received(:track_updated)
    end
  end

  context "#team_name" do
    it "creates a new team" do
      user = create(:user)

      user.team_name = "team name"
      user.save

      expect(user.team).to be_present
      expect(user.team.owner).to eq user
      expect(user.team.name).to eq "team name"
    end
  end

  context "#first_name" do
    it "has a first_name that is the first part of name" do
      user = User.new(name: "first last")
      expect(user.first_name).to eq "first"
    end
  end

  context "#last_name" do
    it "returns everything except the first name" do
      user = User.new(name: "First Last")
      expect(user.last_name).to eq "Last"

      user_with_multi_part_last_name = User.new(name: "First van der Last")
      expect(user_with_multi_part_last_name.last_name).to eq "van der Last"
    end
  end

  context "password validations" do
    it "allows non-oauth users to update attributes without the password" do
      user = create_user_without_cached_password(admin: false)

      user.admin = true
      user.save

      expect(user.reload).to be_admin
    end

    def create_user_without_cached_password(attributes)
      user = create(:user, attributes)
      User.find(user.id)
    end
  end

  describe "#has_access_to?" do
    it "returns true for all features for all users" do
      user = build_stubbed(:user)

      expect(user).to have_access_to(double(:foo))
    end
  end

  describe "#has_completed_trails?" do
    context "when the user has completed one or more trails" do
      it "returns true" do
        user = create(:user)
        create(:status, :completed, completeable: create(:trail), user: user)

        expect(user).to have_completed_trails
      end
    end

    context "when the user has not completed any trails" do
      it "returns false" do
        user = create(:user)

        expect(user).not_to have_completed_trails
      end
    end
  end
end
