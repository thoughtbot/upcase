require 'spec_helper'

describe SendSectionReminderEmailJob do
  it_behaves_like 'a Delayed Job that notifies Airbrake about errors'

  describe '.enqueue' do
    it 'enqueues a job' do
      purchase = create(:purchase)
      section = create(:section)

      SendSectionReminderEmailJob.enqueue(purchase.id, section.id).should
        enqueue_delayed_job(SendSectionReminderEmailJob)
    end
  end

  describe '#perform' do
    it 'sends a follow up email' do
      purchase = stubbed_purchase
      section = build_stubbed(:section)
      Section.stubs(:find).with(section.id).returns(section)
      mail_stub = stub_mail_method(:section_reminder)

      SendSectionReminderEmailJob.new(purchase.id, section.id).perform

      Mailer.should have_received(:section_reminder).with(purchase, section)
      mail_stub.should have_received(:deliver)
    end
  end
end
