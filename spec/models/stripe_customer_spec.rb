require "rails_helper"

describe StripeCustomer do
  describe '#url' do
    it 'returns a url to the customer in the stripe management console' do
      stripe_customer_id = 'whatever'
      url = "https://manage.stripe.com/customers/#{stripe_customer_id}"
      user = User.new(stripe_customer_id: stripe_customer_id)

      expect(StripeCustomer.new(user).url).to eq(url)
    end

    it 'returns nil if the user has no stripe_customer_id' do
      user = User.new(stripe_customer_id: nil)

      expect(StripeCustomer.new(user).url).to be_nil
    end
  end
end
