require 'spec_helper'

describe SectionNotifier do
  it 'sends a notification for items occurring today' do
    mailer = stub(deliver: true)
    Mailer.stubs(section_notification: mailer)

    item_needing_notification = stub(:starts_today? => true)
    item_not_needing_notification = stub(:starts_today? => false)
    items = [item_needing_notification, item_not_needing_notification]
    purchases = [stub(starts_on: Date.today, email: "test@example.com"), stub(starts_on: Date.today, email: "test2@example.com")]
    section = stub

    notifier = SectionNotifier.new(section, purchases)
    notifier.send_notifications_for(items)

    purchases.each do |purchase|
      expect(Mailer).to have_received(:section_notification).with(purchase.email, item_needing_notification)
      expect(Mailer).to have_received(:section_notification).with(purchase.email, item_not_needing_notification).never
    end
    expect(mailer).to have_received(:deliver).times(2)
  end
end
