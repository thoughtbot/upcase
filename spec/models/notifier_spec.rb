require 'spec_helper'

describe Notifier do
  it 'sends a notification for items occurring today' do
    mailer.stubs(deliver: true)
    Mailer.stubs(notification: mailer)

    item_needing_notification = stub(:starts_today? => true)
    item_not_needing_notification = stub(:starts_today? => false)
    items = [item_needing_notification, item_not_needing_notification]
    emails = ["test@example.com", "test2@example.com"]
    section = stub(start_date: Date.today)

    notifier = Notifier.new(section, emails)
    notifier.send_notifications_for(items)

    emails.each do |email|
      expect(Mailer).to have_received(:notification).with(email, item_needing_notification)
      expect(Mailer).to have_received(:notification).with(email, item_not_needing_notification).never
    end
  end
end
