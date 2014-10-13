require "rails_helper"

describe Acceptance do
  it "should be ActiveModel-compliant" do
    acceptance = build(:acceptance)
    expect(acceptance).to be_a(ActiveModel::Model)
  end

  describe "validations" do
    it "validates presence of github_username" do
      acceptance = build(:acceptance, github_username: "")

      expect(acceptance).to be_invalid
      expect(acceptance.errors[:github_username]).to eq(["can't be blank"])
    end

    it "bubbles up user validations" do
      acceptance = build(:acceptance, password: "")

      expect(acceptance).to be_invalid
      expect(acceptance.errors[:password]).to eq(["can't be blank"])
    end

    it "requires user password if user is pre-existing" do
      user = build_stubbed(:user, :with_github, password: "password")
      user.stubs(:authenticated?).returns(false)
      User.stubs(:find_by).returns(user)
      acceptance = build(:acceptance, email: user.email, password: "other")

      expect(acceptance).to be_invalid
      expect(acceptance.errors[:password]).to eq(["password is incorrect"])
    end

    it "sets user password if user doesn't exist" do
      acceptance = build(:acceptance, password: "other")

      expect(acceptance).to be_valid
      expect(acceptance.user.password).to eq("other")
    end

    it "ensures the invitation has not been accepted" do
      invitation = build_stubbed(:invitation)
      invitation.stubs(:accepted?).returns(true)
      acceptance = build(:acceptance, invitation: invitation)

      expect(acceptance).to be_invalid
      expect(acceptance.errors[:invitation]).to eq(["has already been accepted"])
    end
  end

  describe "#initialize" do
    it "returns attributes given during initialization" do
      invitation = build_stubbed(:invitation)
      acceptance = build(
        :acceptance,
        github_username: "billyboy",
        invitation: invitation,
        name: "Bill",
        password: "secret"
      )

      expect(acceptance.github_username).to eq("billyboy")
      expect(acceptance.name).to eq("Bill")
      expect(acceptance.password).to eq("secret")
      expect(acceptance.invitation).to eq(invitation)
    end
  end

  describe "#save" do
    it "accepts an invitation for a new user" do
      invitation = build_stubbed(:invitation)
      invitation.stubs(:accept)
      acceptance = build(:acceptance, invitation: invitation)

      result = acceptance.save

      user = User.authenticate(invitation.email, acceptance.password)
      expect(user).to be_present
      expect(user).to eq(acceptance.user)
      expect(invitation).to have_received(:accept).with(user)
      expect(result).to be true
    end

    it "accepts an invitation for an existing user with correct password" do
      user = create(:user, github_username: "billyboy", password: "password")
      invitation = create(:invitation, email: user.email)
      acceptance = build(:acceptance, invitation: invitation, password: "password")

      result = acceptance.save

      expect(user.reload.team).to eq(invitation.team)
      expect(result).to be true
    end

    it "rejects an invitation for an existing user with incorrect password" do
      user = create(:user, github_username: "billyboy", password: "password")
      invitation = create(:invitation, email: user.email)
      acceptance = build(:acceptance, invitation: invitation, password: "other")

      result = acceptance.save

      expect(user.reload.team).to be_nil
      expect(result).to be false
    end
  end
end
