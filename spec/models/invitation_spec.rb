require 'spec_helper'

describe Invitation do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:sender_id) }
  it { should validate_presence_of(:team_id) }

  it { should belong_to(:recipient) }
  it { should belong_to(:sender) }
  it { should belong_to(:team) }

  it 'limits the number of invitations' do
    team = build_stubbed(:team)
    team.stubs(:has_users_remaining?).returns(false)

    invitation = build_stubbed(:invitation, team: team)

    expect(invitation).to be_invalid
    expect(invitation.errors[:team]).to eq(['has no users remaining'])
  end

  describe '#deliver' do
    it 'saves and sends a valid invitation' do
      mailer = stub_mailer
      invitation = build(:invitation)

      result = invitation.deliver

      expect(invitation).to be_persisted
      expect(mailer).to have_received(:invitation).with(invitation.id)
      expect(result).to be_true
    end

    it "doesn't send an invalid invitation" do
      mailer = stub_mailer
      invitation = build(:invitation, email: '')

      result = invitation.deliver

      expect(mailer).to have_received(:invitation).never
      expect(result).to be_false
    end

    def stub_mailer
      stub('mailer', :invitation).tap do |mailer|
        InvitationMailer.stubs(:delay).returns(mailer)
      end
    end
  end

  describe '#code' do
    it' generates a code' do
      invitation = create(:invitation)

      invitation.deliver

      expect(invitation.code).to be_present
    end

    it 'generates a new code for each invitation' do
      first_invitation = create(:invitation)
      second_invitation = create(:invitation)

      expect(first_invitation.code).not_to eq(second_invitation.code)
    end
  end

  describe '#to_param' do
    it 'returns its code' do
      invitation = create(:invitation)

      expect(invitation.to_param).to eq(invitation.code)
    end
  end

  describe '.find' do
    it 'finds models by code' do
      invitation = create(:invitation)

      expect(Invitation.find(invitation.code)).to eq(invitation)
    end

    it 'finds models by ID' do
      invitation = create(:invitation)

      expect(Invitation.find(invitation.id)).to eq(invitation)
    end
  end

  describe '#accept' do
    it 'adds the user to the team' do
      Timecop.freeze Time.now.beginning_of_day do
        team = build_stubbed(:team)
        team.stubs(:add_user)
        user = create(:user)
        invitation = create(:invitation, team: team)

        invitation.accept(user)

        expect(team).to have_received(:add_user).with(user)
        expect(invitation.reload.accepted_at).to eq(Time.now)
        expect(invitation.reload.recipient).to eq(user)
      end
    end
  end

  describe '#accepted?' do
    it 'returns true if accepted' do
      invitation = build_stubbed(:invitation, accepted_at: Time.now)

      expect(invitation).to be_accepted
    end

    it 'returns false if unaccepted' do
      invitation = build_stubbed(:invitation, nil)

      expect(invitation).not_to be_accepted
    end
  end

  describe '#has_users_remaining?' do
    it 'delegates to its team' do
      team = build_stubbed(:team)
      team.stubs(:has_users_remaining?).returns('expected value')
      invitation = build_stubbed(:invitation, team: team)

      expect(invitation.has_users_remaining?).to eq('expected value')
    end
  end

  describe '#sender_name' do
    it 'delegates to its sender' do
      sender = build_stubbed(:user, name: 'Billy Boy')
      invitation = build_stubbed(:invitation, sender: sender)

      expect(invitation.sender_name).to eq('Billy Boy')
    end
  end
end
