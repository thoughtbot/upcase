require 'spec_helper'

describe AssociatePreviousPurchases, '.create_associations_for' do
  it 'associates purchases and the stripe customer id' do
    user = create(:user)
    associator_stub = stub(associate_purchases: true, associate_stripe_customer_id: true)
    AssociatePreviousPurchases.stubs(new: associator_stub)

    AssociatePreviousPurchases.create_associations_for(user)

    expect(associator_stub).to have_received(:associate_purchases)
    expect(associator_stub).to have_received(:associate_stripe_customer_id)
  end
end

describe AssociatePreviousPurchases, '#associate_stripe_customer_id' do
  it 'replaces their stripe_customer_id with the previously existing stripe_customer_id' do
    user = create(:user, stripe_customer_id: '1234')
    stripe_purchase = create(:stripe_purchase, email: user.email)

    AssociatePreviousPurchases.new(user).associate_stripe_customer_id

    expect(user.stripe_customer_id).to eq stripe_purchase.stripe_customer_id
  end
end

describe AssociatePreviousPurchases, '#associate_purchases' do
  context 'when there are previous purchases' do
    it 'associates only purchases with matching emails' do
      user = create(:user)
      previous_purchase = create(:purchase, email: user.email)
      other_purchase = create(:purchase, email: 'another@example.com')
      expect(user.purchases).to be_empty

      AssociatePreviousPurchases.new(user).associate_purchases

      expect(user.purchases).to eq [previous_purchase]
    end
  end

  context 'when there are no previous purchases' do
    it 'does not associate the user with any purchases' do
      user = create(:user)

      AssociatePreviousPurchases.new(user).associate_purchases

      expect(user.purchases).to be_empty
    end
  end
end
