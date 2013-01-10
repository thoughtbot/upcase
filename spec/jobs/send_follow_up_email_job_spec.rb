require 'spec_helper'

describe SendFollowUpEmailJob do
  it_behaves_like 'a Delayed Job that notifies Airbrake about errors'

  describe '.enqueue' do
    it 'enqueues a job' do
      follow_up = create(:follow_up)
      section = create(:section)

      SendFollowUpEmailJob.enqueue(follow_up.id, section.id).should
        enqueue_delayed_job(SendFollowUpEmailJob)
    end
  end

  describe '#perform' do
    it 'sends a follow up email' do
      follow_up = create(:follow_up)
      section = create(:section)
      mail_stub = stub_mail_method(:follow_up)

      SendFollowUpEmailJob.new(follow_up.id, section.id).perform

      Mailer.should have_received(:follow_up).with(follow_up, section)
      mail_stub.should have_received(:deliver)
    end

    it 'sets notified_at to Time.now' do
      follow_up = create(:follow_up)
      section = create(:section)

      follow_up.notified_at.should be_nil

      Timecop.freeze(Time.now) do
        SendFollowUpEmailJob.new(follow_up.id, section.id).perform
        follow_up.reload.notified_at.to_i.should == Time.now.to_i
      end
    end
  end
end
