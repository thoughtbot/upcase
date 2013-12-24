require 'spec_helper'

describe PurchaseRefunder, '#refund' do
  it 'sets the purchase as unpaid' do
    purchase = create(:paid_purchase)

    PurchaseRefunder.new(purchase).refund

    expect(purchase).not_to be_paid
  end

  it 'does not issue a refund if it is unpaid' do
    payment = stub('payment', place: true)
    Payments::StripePayment.stubs(:new).returns(payment)
    purchase = create(:unpaid_purchase)

    PurchaseRefunder.new(purchase).refund

    expect(payment).to have_received(:refund).never
    expect(purchase).not_to be_paid
  end

  context 'when not fulfilled_with_github' do
    it 'does not remove from github' do
      purchase = create(:paid_purchase)
      fulfillment = stub(:remove)
      GithubFulfillment.stubs(:new).returns(fulfillment)

      PurchaseRefunder.new(purchase).refund

      expect(fulfillment).to have_received(:remove).never
    end
  end

  context 'when fulfilled_with_github' do
    it 'removes from github' do
      product = create(:book, :github)
      purchase = create(:paid_purchase, purchaseable: product)
      fulfillment = stub(:remove)
      GithubFulfillment.stubs(:new).returns(fulfillment)

      PurchaseRefunder.new(purchase).refund

      expect(fulfillment).to have_received(:remove)
    end
  end

  context 'with stripe' do
    it 'refunds money to purchaser' do
      purchase = build(:paid_purchase, payment_method: 'stripe')
      payment = stub('payment', refund: true, place: true)
      Payments::StripePayment.stubs(:new).with(purchase).returns(payment)

      PurchaseRefunder.new(purchase).refund

      expect(payment).to have_received(:refund)
    end
  end

  context 'with paypal' do
    it 'refunds money to purchaser' do
      purchase = build(:paid_purchase, payment_method: 'paypal')
      payment = stub('payment', refund: true, place: true)
      Payments::PaypalPayment.stubs(:new).with(purchase).returns(payment)

      PurchaseRefunder.new(purchase).refund

      expect(payment).to have_received(:refund)
      expect(purchase.reload).not_to be_paid
    end
  end
end
