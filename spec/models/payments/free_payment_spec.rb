require 'spec_helper'

describe Payments::FreePayment do
  context '#place' do
    it 'returns true' do
      build_payment.place.should be_true
    end
  end

  context '#update_user' do
    it 'does nothing' do
      purchase = stub('purchase')
      payment = Payments::FreePayment.new(purchase)

      expect { payment.update_user(stub('user')) }.not_to raise_error
    end
  end

  context '#refund' do
    it 'does nothing' do
      purchase = stub('purchase')
      payment = Payments::FreePayment.new(purchase)

      expect { payment.refund }.not_to raise_error
    end
  end

  def build_payment
    purchase = stub('purchase')
    Payments::FreePayment.new(purchase)
  end
end
