require 'spec_helper'

describe SubscriptionCoupon do
  it 'has a code of the given stripe coupon code' do
    subscription_coupon = SubscriptionCoupon.new('25OFF')
    expect(subscription_coupon.code).to eq '25OFF'
  end

  it 'uses the corresponding stripe coupon' do
    stripe_coupon = create_stripe_coupon(id: '25OFF', amount_off: 2500, duration: 'once')
    subscription_coupon = SubscriptionCoupon.new('25OFF')

    expect(subscription_coupon.stripe_coupon.id).to eq stripe_coupon.id
  end

  it 'delegates duration to stripe_coupon' do
    stripe_coupon = create_stripe_coupon(id: '25OFF', amount_off: 2500, duration: 'once')
    subscription_coupon = SubscriptionCoupon.new('25OFF')

    expect(subscription_coupon.duration).to eq 'once'
  end

  it 'delegates duration_in_months to stripe_coupon' do
    stripe_coupon = create_stripe_coupon(id: '25OFF', amount_off: 2500, duration: 'once', duration_in_months: 3)
    subscription_coupon = SubscriptionCoupon.new('25OFF')

    expect(subscription_coupon.duration_in_months).to eq '3'
  end

  context 'apply' do
    it 'returns the discounted amount' do
      create_stripe_coupon(id: '25OFF', amount_off: 2500, duration: 'forever')
      subscription_coupon = SubscriptionCoupon.new('25OFF')

      amount = subscription_coupon.apply(99)

      expect(amount).to eq 74
    end
  end

  it 'is not valid if the coupon code does not exist' do
    exception = Stripe::InvalidRequestError.new('No such coupon', 'NONE')
    Stripe::Coupon.stubs(:retrieve).raises(exception)
    subscription_coupon = SubscriptionCoupon.new('NONE')

    expect(subscription_coupon).not_to be_valid
  end

  def create_stripe_coupon(attributes)
    Stripe::Coupon.create(attributes)
  end

  def build_subscription_purchase_with_price(individual_price)
    subscribeable_product = create(:subscribeable_product,
      individual_price: individual_price)
    build(:subscription_purchase, purchaseable: subscribeable_product)
  end
end
