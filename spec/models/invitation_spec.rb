require "rails_helper"

RSpec.describe Invitation do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:sender_id) }
  it { should validate_presence_of(:team_id) }

  it { should belong_to(:recipient).optional }
  it { should belong_to(:sender) }
  it { should belong_to(:team) }

  describe "#deliver" do
    it "saves and sends a valid invitation" do
      mailer = stub_mailer
      invitation = build(:invitation)

      result = invitation.deliver

      expect(invitation).to be_persisted
      expect(mailer).to have_received(:invitation).with(invitation.id)
      expect(result).to be true
    end

    it "doesn't send an invalid invitation" do
      mailer = stub_mailer
      invitation = build(:invitation, email: "")

      result = invitation.deliver

      expect(mailer).not_to have_received(:invitation)
      expect(result).to be false
    end

    def stub_mailer
      spy("mailer").tap do |mailer|
        allow(InvitationMailer).to receive(:delay).and_return(mailer)
      end
    end
  end

  describe "#code" do
    it "generates a code" do
      invitation = create(:invitation)

      invitation.deliver

      expect(invitation.code).to be_present
    end

    it "generates a new code for each invitation" do
      first_invitation = create(:invitation)
      second_invitation = create(:invitation)

      expect(first_invitation.code).not_to eq(second_invitation.code)
    end
  end

  describe "#to_param" do
    it "returns its code" do
      invitation = create(:invitation)

      expect(invitation.to_param).to eq(invitation.code)
    end
  end

  describe ".find" do
    it "finds models by code" do
      invitation = create(:invitation)

      expect(Invitation.find(invitation.code)).to eq(invitation)
    end

    it "finds models by ID" do
      invitation = create(:invitation)

      expect(Invitation.find(invitation.id)).to eq(invitation)
    end
  end

  describe "#accept" do
    it "adds the user to the team" do
      Timecop.freeze Time.current.beginning_of_day do
        team = build_stubbed(:team)
        allow(team).to receive(:add_user)
        user = create(:user)
        invitation = create(:invitation, team: team)

        invitation.accept(user)

        expect(team).to have_received(:add_user).with(user)
        expect(invitation.reload.accepted_at).to eq(Time.current)
        expect(invitation.reload.recipient).to eq(user)
      end
    end

    context "when the invitation is already accepted" do
      it "returns falsey" do
        invitation = Invitation.new(accepted_at: Time.current)
        user = User.new

        result = invitation.accept(user)

        expect(result).to be_falsey
      end
    end
  end

  describe "#accepted?" do
    it "returns true if accepted" do
      invitation = build_stubbed(:invitation, accepted_at: Time.current)

      expect(invitation).to be_accepted
    end

    it "returns false if unaccepted" do
      invitation = build_stubbed(:invitation, accepted_at: nil)

      expect(invitation).not_to be_accepted
    end
  end

  describe "#sender_name" do
    it "delegates to its sender" do
      sender = build_stubbed(:user, name: "Billy Boy")
      invitation = build_stubbed(:invitation, sender: sender)

      expect(invitation.sender_name).to eq("Billy Boy")
    end
  end

  describe ".pending" do
    it "includes only invitations that have not been accepted" do
      pending = create(:invitation)
      create(:invitation, :accepted)

      expect(Invitation.pending).to eq [pending]
    end
  end
end
