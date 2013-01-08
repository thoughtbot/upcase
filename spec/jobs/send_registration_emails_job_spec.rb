require 'spec_helper'

describe SendRegistrationEmailsJob do
  describe '.enqueue' do
    it 'enqueues a job' do
      purchase = create(:section_purchase)

      SendRegistrationEmailsJob.enqueue(purchase.id).should
        enqueue_delayed_job(SendRegistrationEmailsJob)
    end
  end

  describe '#perform' do
    it 'sends a registration notification' do
      purchase = stubbed_purchase
      mail_stub = stub_mail_method(:registration_notification)

      SendRegistrationEmailsJob.new(purchase.id).perform

      Mailer.should have_received(:registration_notification).with(purchase)
      mail_stub.should have_received(:deliver)
    end

    it 'sends a registration confirmation' do
      purchase = stubbed_purchase
      mail_stub = stub_mail_method(:registration_confirmation)

      SendRegistrationEmailsJob.new(purchase.id).perform

      Mailer.should have_received(:registration_confirmation).with(purchase)
      mail_stub.should have_received(:deliver)
    end

    def stubbed_purchase
      build_stubbed(:section_purchase).tap do |purchase|
        Purchase.stubs(:find).with(purchase.id).returns(purchase)
      end
    end

    def stub_mail_method(method_name)
      stub('mail', deliver: true).tap do |mail|
        Mailer.stubs(method_name => mail)
      end
    end
  end
end
