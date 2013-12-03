require 'spec_helper'

describe NullCoupon, '#apply' do
  it 'returns the full price' do
    null_coupon = NullCoupon.new
    full_price = 20

    price_after_coupon_is_applied = null_coupon.apply(full_price)

    expect(price_after_coupon_is_applied).to eq full_price
  end
end
