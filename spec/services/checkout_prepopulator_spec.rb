require 'rails_helper'

describe CheckoutPrepopulator, '#prepopulate_with_user_info' do
  it 'populates default info when given a subscriber' do
    plan = create(:individual_plan)
    checkout = plan.checkouts.build
    subscriber = create_subscriber
    CheckoutPrepopulator.new(checkout, subscriber).prepopulate_with_user_info

    expect(checkout.name).to eq subscriber.name
    expect(checkout.email).to eq subscriber.email
    expect(checkout.github_username).to eq subscriber.github_username
    expect(checkout.organization).to eq 'thoughtbot'
    expect(checkout.address1).to eq '41 Winter St.'
    expect(checkout.address2).to eq 'Floor 7'
    expect(checkout.city).to eq 'Boston'
    expect(checkout.state).to eq 'MA'
    expect(checkout.zip_code).to eq '02108'
    expect(checkout.country).to eq 'USA'
  end

  private

  def create_subscriber
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
