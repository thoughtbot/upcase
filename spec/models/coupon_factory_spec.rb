require 'spec_helper'

describe CouponFactory, '.for_purchase' do
  it 'returns the coupon associated with the purchase if it is present' do
    coupon = build(:one_time_coupon, amount: 25)
    purchase = build(:purchase, coupon: coupon, paid: true)

    coupon_from_factory = CouponFactory.for_purchase(purchase)

    expect(coupon_from_factory).to eq coupon
  end

  it 'returns a subscription coupon if a stripe_coupon_id is present' do
    subscription_coupon = double(apply: 20)
    SubscriptionCoupon.stubs(:new).returns(subscription_coupon)
    purchase = build(:plan_purchase, stripe_coupon_id: '25OFF')

    coupon_from_factory = CouponFactory.for_purchase(purchase)

    expect(coupon_from_factory).to eq subscription_coupon
  end

  it 'returns a null coupon when there are no regular or subscription coupons' do
    null_coupon_stub = double('null_coupon')
    NullCoupon.stubs(new: null_coupon_stub)
    purchase = build(:purchase)

    coupon_from_factory = CouponFactory.for_purchase(purchase)

    expect(coupon_from_factory).to eq null_coupon_stub
  end
end
