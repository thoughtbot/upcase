require 'spec_helper'

describe VideoNotifier do
  it 'sends a notification for videos occurring today' do
    mailer = stub(deliver: true)
    Mailer.stubs(video_notification: mailer)

    video_needing_notification = stub(:starts_today? => true)
    video_not_needing_notification = stub(:starts_today? => false)
    videos = [video_needing_notification, video_not_needing_notification]
    purchases = [
      stub(starts_on: Time.zone.today, email: "test@example.com"),
      stub(starts_on: Time.zone.today, email: "test2@example.com")
    ]
    section = stub

    notifier = VideoNotifier.new(section, purchases)
    notifier.send_notifications_for(videos)

    purchases.each do |purchase|
      expect(Mailer).to have_received(:video_notification).with(purchase.email, video_needing_notification)
      expect(Mailer).to have_received(:video_notification).with(purchase.email, video_not_needing_notification).never
    end
    expect(mailer).to have_received(:deliver).times(2)
  end
end
