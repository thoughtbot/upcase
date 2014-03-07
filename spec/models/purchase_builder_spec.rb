require 'spec_helper'

describe PurchaseBuilder do
  describe '#build' do
    it 'sets the coupon if one is present' do
      coupon = create(:coupon, active: true)

      purchase = build_purchase(params: purchase_params(coupon_id: coupon.id))

      expect(purchase.coupon).to eq(coupon)
    end

    it 'sets the user if the user is present' do
      user = build_stubbed(:user)

      purchase = build_purchase(params: purchase_params, user: user)

      expect(purchase.user).to eq(user)
    end

    it 'sets the stripe id if user is present and using an existing card' do
      user = build_stubbed(:user, stripe_customer_id: 'stripe-id-123')

      purchase =
        build_purchase(
          params: purchase_params(use_existing_card: 'on'),
          user: user
        )

      expect(purchase.stripe_customer_id).to eq('stripe-id-123')
    end

    it 'does not set the stripe id if there is no user' do
      purchase =
        build_purchase(params: purchase_params(use_existing_card: 'on'))

      expect(purchase.stripe_customer_id).to be_nil
    end

    it 'does not set the stripe id if we are not using an existing card' do
      user = build_stubbed(:user, stripe_customer_id: 'cus12345')

      purchase =
        build_purchase(
          params: purchase_params(use_existing_card: 'off'),
          user: user
        )

      expect(purchase.stripe_customer_id).to be_nil
    end

    def purchase_params(params = {})
      params[:purchase] ||= { name: 'anything' }
      ActionController::Parameters.new(params)
    end

    def build_purchase(options)
      params = options[:params] || purchase_params
      user = options[:user]

      purchases = create(:workshop).purchases

      PurchaseBuilder.new(
        params: params,
        user: user,
        purchases_collection: purchases
      ).build
    end
  end
end
