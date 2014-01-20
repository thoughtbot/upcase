require 'spec_helper'

describe Acceptance do
  it 'should be ActiveModel-compliant' do
    acceptance = build(:acceptance)
    expect(acceptance).to be_a(ActiveModel::Model)
  end

  describe 'validations' do
    it 'validates presence of github_username' do
      acceptance = build(:acceptance, github_username: '')

      expect(acceptance).to be_invalid
      expect(acceptance.errors[:github_username]).to eq(["can't be blank"])
    end

    it 'bubbles up user validations' do
      acceptance = build(:acceptance, password: '')

      expect(acceptance).to be_invalid
      expect(acceptance.errors[:password]).to eq(["can't be blank"])
    end

    it 'ensures the invitation has not been accepted' do
      invitation = build_stubbed(:invitation)
      invitation.stubs(:accepted?).returns(true)
      acceptance = build(:acceptance, invitation: invitation)

      expect(acceptance).to be_invalid
      expect(acceptance.errors[:invitation]).to eq(['has already been accepted'])
    end
  end

  describe '#initialize' do
    it 'returns attributes given during initialization' do
      invitation = build_stubbed(:invitation)
      acceptance = build(
        :acceptance,
        github_username: 'billyboy',
        invitation: invitation,
        name: 'Bill',
        password: 'secret'
      )

      expect(acceptance.github_username).to eq('billyboy')
      expect(acceptance.name).to eq('Bill')
      expect(acceptance.password).to eq('secret')
      expect(acceptance.invitation).to eq(invitation)
    end
  end

  describe '#save' do
    it 'accepts an invitation for a new user' do
      invitation = build_stubbed(:invitation)
      invitation.stubs(:accept)
      acceptance = build(:acceptance, invitation: invitation)

      result = acceptance.save

      user = User.authenticate(invitation.email, acceptance.password)
      expect(user).to be_present
      expect(user).to eq(acceptance.user)
      expect(invitation).to have_received(:accept).with(user)
      expect(result).to be_true
    end
  end
end
