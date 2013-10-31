require 'spec_helper'

describe PurchaseInfoCopier, '#copy_info_to_user' do
  context 'with github_usernames' do
    it 'saves the first github_username to the user' do
      user = create(:user)
      expect(user.github_username).to be_blank
      purchase = build(:purchase, user: user, github_usernames: ['tbot', 'other'])

      PurchaseInfoCopier.new(purchase, user).copy_info_to_user

      expect(user.github_username).to eq 'tbot'
    end

    it "doesn't overwrite first github_username to the user" do
      user = create(:user, github_username: 'test')
      purchase = build(:purchase, user: user, github_usernames: ['tbot', 'other'])

      PurchaseInfoCopier.new(purchase, user).copy_info_to_user

      expect(user.github_username).to eq 'test'
    end
  end

  context 'with address information' do
    it 'saves the address to the user' do
      user = create(:user)
      user.address1.should be_blank
      purchase = build(
        :purchase,
        user: user,
        organization: 'thoughtbot',
        address1: '41 Winter St.',
        address2: 'Floor 7',
        city: 'Boston',
        state: 'MA',
        zip_code: '02108',
        country: 'USA'
      )

      PurchaseInfoCopier.new(purchase, user).copy_info_to_user

      expect(user.organization).to eq 'thoughtbot'
      expect(user.address1).to eq '41 Winter St.'
      expect(user.address2).to eq 'Floor 7'
      expect(user.city).to eq 'Boston'
      expect(user.state).to eq 'MA'
      expect(user.zip_code).to eq '02108'
      expect(user.country).to eq 'USA'
    end

    it "doesn't overwite the organization with blank" do
      user = create(:user, organization: 'thoughtbot')
      purchase = build(
        :purchase,
        user: user,
        organization: ''
      )

      PurchaseInfoCopier.new(purchase, user).copy_info_to_user

      expect(user.organization).to eq 'thoughtbot'
    end

    it 'overwrites the address if provided' do
      user = create(:user, address1: 'testing')
      purchase = build(
        :purchase,
        user: user,
        organization: 'thoughtbot',
        address1: '41 Winter St.',
        address2: 'Floor 7',
        city: 'Boston',
        state: 'MA',
        zip_code: '02108',
        country: 'USA'
      )

      PurchaseInfoCopier.new(purchase, user).copy_info_to_user

      expect(user.address1).to eq '41 Winter St.'
      expect(user.address2).to eq 'Floor 7'
      expect(user.city).to eq 'Boston'
      expect(user.state).to eq 'MA'
      expect(user.zip_code).to eq '02108'
      expect(user.country).to eq 'USA'
    end

    it "doesn't overwrite the address if not provided" do
      user = create(:user, address1: 'testing')
      purchase = build(
        :purchase,
        user: user,
        address1: '',
        address2: 'Floor 7',
        city: 'Boston',
        state: 'MA',
        zip_code: '02108',
        country: 'USA'
      )

      PurchaseInfoCopier.new(purchase, user).copy_info_to_user

      expect(user.address1).to eq 'testing'
      expect(user.address2).to be_blank
      expect(user.city).to be_blank
      expect(user.state).to be_blank
      expect(user.zip_code).to be_blank
      expect(user.country).to be_blank
    end
  end
end

