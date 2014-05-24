require 'spec_helper'

describe Payments::FreePayment do
  it 'implements #update_user' do
    expect(build_payment).to respond_to(:update_user).with(1).argument
  end

  it 'implements #refund' do
    expect(build_payment).to respond_to(:refund)
  end

  context '#place' do
    it 'returns true' do
      expect(build_payment.place).to be_true
    end

    it 'sets the purchase as paid' do
      purchase = build_free_purchase
      payment = Payments::FreePayment.new(purchase)

      payment.place

      expect(purchase).to have_received(:set_as_paid)
    end
  end

  def build_payment
    purchase = build_free_purchase
    Payments::FreePayment.new(purchase)
  end

  def build_free_purchase
    double('purchase', set_as_paid: true)
  end
end
