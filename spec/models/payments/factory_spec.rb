require 'spec_helper'

describe Payments::Factory do
  context '#new' do
    it 'builds a payment for the given purchase and payment method' do
      purchase = stub('purchase')
      payment = stub('payment')
      payment_class = stub('payment_class')
      payment_method = 'fake'
      Payments.stubs(:const_get).with('FakePayment').returns(payment_class)
      payment_class.stubs(:new).with(purchase).returns(payment)
      factory = Payments::Factory.new(payment_method)

      result = factory.new(purchase)

      result.should eq payment
    end
  end
end
