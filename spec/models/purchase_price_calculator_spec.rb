 require 'spec_helper'

 describe PurchasePriceCalculator, '#calculate' do
   it 'uses the coupon in its charged price' do
     coupon = build_stubbed(:coupon, amount: 25)
     product = build_stubbed(:product, individual_price: 40)
     purchase = build_stubbed(
       :purchase,
       coupon: coupon,
       purchaseable: product,
       variant: 'individual'
     )

     purchase_calculator = PurchasePriceCalculator.new(purchase)

     expect(purchase_calculator.calculate).to eq 30
   end

   it 'calculates its price using the subscription coupon when there is a stripe coupon' do
     subscription_coupon = stub(apply: 20)
     SubscriptionCoupon.stubs(:new).returns(subscription_coupon)
     purchase = create(:plan_purchase, stripe_coupon_id: '25OFF')

     purchase_calculator = PurchasePriceCalculator.new(purchase)

     expect(purchase_calculator.calculate).to eq 20
   end

   it 'computes its final price from its product variant' do
     product = build_stubbed(:product, individual_price: 15, company_price: 50)
     individual_purchase =
       build_stubbed(:purchase, variant: 'individual', purchaseable: product)
     company_purchase =
       build_stubbed(:purchase, variant: 'company', purchaseable: product)

     individual_purchase_calculator = PurchasePriceCalculator.new(individual_purchase)
     company_purchase_calculator = PurchasePriceCalculator.new(company_purchase)

     expect(individual_purchase_calculator.calculate).to eq 15
     expect(company_purchase_calculator.calculate).to eq 50
   end
 end
