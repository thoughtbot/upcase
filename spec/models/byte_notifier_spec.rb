require 'spec_helper'

describe ByteNotifier do
  it 'sends a notification for bytes being published today' do
    mailer.stubs(deliver: true)
    Mailer.stubs(byte_notification: mailer)

    byte_needing_notification = stub
    byte_not_needing_notification = stub
    Article.stubs(:bytes_published_today).returns([byte_needing_notification])
    emails = ["test@example.com", "test2@example.com"]

    notifier = ByteNotifier.new(emails)
    notifier.send_notifications

    emails.each do |email|
      expect(Mailer).to have_received(:byte_notification).
        with(email, byte_needing_notification)
      expect(Mailer).to have_received(:byte_notification).
        with(email, byte_not_needing_notification).never
    end
    expect(mailer).to have_received(:deliver).times(2)
  end

  it 'notifies airbrake when there is an error' do
    Mailer.stubs(:byte_notification).raises(Net::SMTPFatalError)
    Article.stubs(:bytes_published_today).returns([stub])
    Airbrake.stubs(:notify)
    notifier = ByteNotifier.new(['test@example.com'])

    expect { notifier.send_notifications }.not_to raise_error
    expect(Airbrake).to have_received :notify
  end
end
