require 'spec_helper'

describe SendPurchaseReceiptEmailJob do
  describe '.enqueue' do
    it 'enqueues a job' do
      purchase = create(:section_purchase)

      SendPurchaseReceiptEmailJob.enqueue(purchase.id).should
        enqueue_delayed_job(SendPurchaseReceiptEmailJob)
    end
  end

  describe '#perform' do
    it 'sends a purchase receipt' do
      purchase = stubbed_purchase
      mail_stub = stub_mail_method(:purchase_receipt)

      SendPurchaseReceiptEmailJob.new(purchase.id).perform

      Mailer.should have_received(:purchase_receipt).with(purchase)
      mail_stub.should have_received(:deliver)
    end
  end
end
