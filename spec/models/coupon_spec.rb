require 'spec_helper'

describe Coupon do
  it { should have_many(:purchases) }

  context "with a discount type of percentage" do
    subject { create(:coupon, amount: 10, discount_type: "percentage") }
    it "applies the coupon as a percentage" do
      subject.apply(50).should == 45
    end
  end

  context "with a discount type of dollars" do
    subject { create(:coupon, amount: 10, discount_type: "dollars") }
    it "applies the coupon as a dollar discount" do
      subject.apply(50).should == 40
    end
  end

  context 'telling the coupon that it has been #applied' do
    it 'produces the full price on the second try if it is one-time use' do
      coupon = create(:one_time_coupon, amount: 10, discount_type: 'dollars')
      coupon.apply(50).should == 40
      coupon.applied
      coupon.apply(50).should == 50
      coupon.should_not be_active
    end

    it 'produces the discounted price each time' do
      coupon = create(:coupon, amount: 10, discount_type: 'dollars')
      coupon.apply(50).should == 40
      coupon.applied
      coupon.apply(50).should == 40
      coupon.should be_active
    end
  end
end

describe Coupon, '.active' do
  it 'returns active coupons' do
    active_coupon = create(:coupon, active: true)
    inactive_coupon = create(:coupon, active: false)

    Coupon.active.should eq [active_coupon]
  end
end
