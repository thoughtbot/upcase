require 'spec_helper'

describe Coupon do
  it { should have_many(:purchases) }

  context "with a discount type of percentage" do
    subject { create(:coupon, amount: 10, discount_type: "percentage") }
    it "applies the coupon as a percentage" do
      expect(subject.apply(50)).to eq(45)
    end
  end

  context "with a discount type of dollars" do
    subject { create(:coupon, amount: 10, discount_type: "dollars") }
    it "applies the coupon as a dollar discount" do
      expect(subject.apply(50)).to eq(40)
    end
  end

  context 'telling the coupon that it has been #applied' do
    it 'produces the full price on the second try if it is one-time use' do
      coupon = create(:one_time_coupon, amount: 10, discount_type: 'dollars')
      expect(coupon.apply(50)).to eq(40)
      coupon.applied
      expect(coupon.apply(50)).to eq(50)
      expect(coupon).not_to be_active
    end

    it 'produces the discounted price each time' do
      coupon = create(:coupon, amount: 10, discount_type: 'dollars')
      expect(coupon.apply(50)).to eq(40)
      coupon.applied
      expect(coupon.apply(50)).to eq(40)
      expect(coupon).to be_active
    end
  end
end

describe Coupon, '.active' do
  it 'returns active coupons' do
    active_coupon = create(:coupon, active: true)
    inactive_coupon = create(:coupon, active: false)

    expect(Coupon.active).to eq [active_coupon]
  end
end
