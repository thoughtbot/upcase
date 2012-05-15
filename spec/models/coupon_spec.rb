require 'spec_helper'

describe Coupon do
  context "with a discount type of percentage" do
    subject { Factory(:coupon, amount: 10, discount_type: "percentage") }
    it "applies the coupon as a percentage" do
      subject.apply(50).should == 45
    end
  end

  context "with a discount type of dollars" do
    subject { Factory(:coupon, amount: 10, discount_type: "dollars") }
    it "applies the coupon as a dollar discount" do
      subject.apply(50).should == 40
    end
  end
end
