require 'spec_helper'

describe SendTeacherNotificationEmailJob do
  it_behaves_like 'a Delayed Job that notifies Airbrake about errors'

  describe '.enqueue' do
    it 'enqueues a job' do
      teacher = create(:teacher)
      section = create(:section)

      SendTeacherNotificationEmailJob.enqueue(teacher.id, section.id).should
        enqueue_delayed_job(SendTeacherNotificationEmailJob)
    end
  end

  describe '#perform' do
    it 'sends a follow up email' do
      teacher = build_stubbed(:teacher)
      Teacher.stubs(:find).with(teacher.id).returns(teacher)
      section = build_stubbed(:section)
      Section.stubs(:find).with(section.id).returns(section)
      mail_stub = stub_mail_method(:teacher_notification)

      SendTeacherNotificationEmailJob.new(teacher.id, section.id).perform

      Mailer.should have_received(:teacher_notification).with(teacher, section)
      mail_stub.should have_received(:deliver)
    end
  end
end
