require 'spec_helper'

describe SendPurchaseReceiptEmailJob do
  it_behaves_like 'a Delayed Job that notifies Airbrake about errors'

  describe '.enqueue' do
    it 'enqueues a job' do
      purchase = create(:purchase)

      expect(SendPurchaseReceiptEmailJob.enqueue(purchase.id)).to
        enqueue_delayed_job(SendPurchaseReceiptEmailJob)
    end
  end

  describe '#perform' do
    it 'sends a purchase receipt' do
      purchase = stubbed_purchase
      mail_stub = stub_mail_method(PurchaseMailer, :purchase_receipt)

      SendPurchaseReceiptEmailJob.new(purchase.id).perform

      expect(PurchaseMailer).to have_received(:purchase_receipt).with(purchase)
      expect(mail_stub).to have_received(:deliver)
    end
  end
end
