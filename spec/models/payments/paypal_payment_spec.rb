require 'spec_helper'

describe Payments::PaypalPayment do
  context '#place' do
    include Rails.application.routes.url_helpers
    let(:host) { ActionMailer::Base.default_url_options[:host] }

    it 'starts a paypal transaction' do
      express_request = stub_express_request
      payment_request = stub_payment_request
      purchase = stub_purchase
      payment = Payments::PaypalPayment.new(purchase)

      payment.place

      Paypal::Payment::Request.
        should have_received(:new).
        with(
          currency_code: :USD,
          amount: purchase.price,
          description: purchase.purchaseable_name,
          items: [
            { amount: purchase.price, description: purchase.purchaseable_name }
          ]
        )
      express_request.
        should have_received(:setup).
          with(
            payment_request,
            paypal_purchase_url(purchase, host: host),
            products_url(host: host)
          )
      purchase.paypal_url.should == 'http://paypalurl'
      purchase.should_not be_paid
    end
  end

  context '#complete' do
    it 'marks the order as paid' do
      stub_express_request(transaction_id: 'TRANSACTION-ID')
      stub_payment_request
      purchase = stub_purchase
      payment = Payments::PaypalPayment.new(purchase)

      payment.complete token: 'TOKEN', PayerID: 'PAYERID'

      purchase.payment_transaction_id.should == 'TRANSACTION-ID'
      purchase.should be_paid
    end
  end

  context '#refund' do
    it 'refunds money to purchaser' do
      express_request = stub_express_request
      purchase = stub_purchase(payment_transaction_id: 'TRANSACTION-ID')
      payment = Payments::PaypalPayment.new(purchase)

      payment.refund

      express_request.should have_received(:refund!).with('TRANSACTION-ID')
    end
  end

  context '#update_user' do
    it 'does nothing' do
      purchase = stub_purchase
      payment = Payments::PaypalPayment.new(purchase)

      expect { payment.update_user(stub('user')) }.not_to raise_error
    end
  end

  context '#host' do
    it 'can produce the host after setting it' do
      Payments::PaypalPayment.host = 'hottiesandcreepers.com:123467'
      Payments::PaypalPayment.host.should == 'hottiesandcreepers.com:123467'
    end

    it 'gives default host when host is not set' do
      Payments::PaypalPayment.host.
        should eq ActionMailer::Base.default_url_options[:host]
    end

    around do |example|
      original_host = Payments::PaypalPayment.host
      begin
        example.run
      ensure
        Payments::PaypalPayment.host = original_host
      end
    end
  end

  def stub_express_request(overrides = {})
    transaction_id = overrides[:transaction_id] || 'TRANSACTION-123'

    stub(
      'express_request',
      setup: stub(redirect_uri: 'http://paypalurl'),
      checkout!: stub(payment_info: [stub(transaction_id: transaction_id)]),
      refund!: nil
    ).tap do |express_request|
      Paypal::Express::Request.stubs(new: express_request)
    end
  end

  def stub_payment_request
    stub('payment_request').tap do |payment_request|
      Paypal::Payment::Request.stubs(new: payment_request)
    end
  end

  def stub_purchase(overrides = {})
    product = create(:product, individual_price: 15, company_price: 50)
    build_stubbed(
      :purchase,
      {
        purchaseable: product,
        payment_method: 'paypal',
        lookup: 'findme'
      }.merge(overrides)
    )
  end
end
