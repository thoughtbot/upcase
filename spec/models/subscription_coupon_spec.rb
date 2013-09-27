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

  it 'is not valid if the coupon code does not exist' do
    exception = Stripe::InvalidRequestError.new('No such coupon', 'NONE')
    Stripe::Coupon.stubs(:retrieve).raises(exception)
    subscription_coupon = SubscriptionCoupon.new('NONE')

    expect(subscription_coupon).not_to be_valid
  end

  describe '#apply' do
    context 'when it is an amount off discount' do
      it 'deducts that dollar amount' do
        create_stripe_coupon(id: '25OFF', amount_off: 2500, duration: 'forever')
        subscription_coupon = SubscriptionCoupon.new('25OFF')

        amount = subscription_coupon.apply(99)

        expect(amount).to eq 74
      end
    end

    context 'when it is a percentage off discount' do
      it 'deducts that percentage off the amount' do
        create_stripe_coupon(id: '50OFF', percent_off: 50, duration: 'forever')
        subscription_coupon = SubscriptionCoupon.new('50OFF')

        amount = subscription_coupon.apply(99)

        expect(amount).to eq 49.50
      end
    end
  end

  def create_stripe_coupon(attributes)
    Stripe::Coupon.create(attributes)
  end
end
