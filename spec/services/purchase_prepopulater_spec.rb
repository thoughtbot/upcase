require 'spec_helper'

describe PurchasePrepopulater, '#prepopulate_with_user_info' do
  it 'populates default info when given a purchaser' do
    product = create(:product)
    purchase = product.purchases.build
    purchaser = create_purchaser
    PurchasePrepopulater.new(purchase, purchaser).prepopulate_with_user_info

    expect(purchase.name).to eq purchaser.name
    expect(purchase.email).to eq purchaser.email
    expect(purchase.github_usernames.try(:first)).to be_blank
    expect(purchase.organization).to eq 'thoughtbot'
    expect(purchase.address1).to eq '41 Winter St.'
    expect(purchase.address2).to eq 'Floor 7'
    expect(purchase.city).to eq 'Boston'
    expect(purchase.state).to eq 'MA'
    expect(purchase.zip_code).to eq '02108'
    expect(purchase.country).to eq 'USA'
  end

  context 'for a product fulfilled through github' do
    it 'populates default info including first github_username' do
      product = create(:book, :github)
      purchase = product.purchases.build
      purchaser = create_purchaser
      PurchasePrepopulater.new(purchase, purchaser).prepopulate_with_user_info

      expect(purchase.name).to eq purchaser.name
      expect(purchase.email).to eq purchaser.email
      expect(purchase.github_usernames.first).to eq purchaser.github_username
    end
  end

  context 'for a subscription plan' do
    it 'populates default info including first github_username' do
      plan = create(:plan)
      purchase = plan.purchases.build
      purchaser = create_purchaser
      PurchasePrepopulater.new(purchase, purchaser).prepopulate_with_user_info

      expect(purchase.name).to eq purchaser.name
      expect(purchase.email).to eq purchaser.email
      expect(purchase.github_usernames.first).to eq purchaser.github_username
    end
  end

  private

  def create_purchaser
    create(
      :user,
      github_username: 'Hello',
      organization: 'thoughtbot',
      address1: '41 Winter St.',
      address2: 'Floor 7',
      city: 'Boston',
      state: 'MA',
      zip_code: '02108',
      country: 'USA'
    )
  end
end
