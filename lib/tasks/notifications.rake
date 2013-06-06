namespace :notifications do
  desc 'Send notifications for current sections'
  task section: :environment do
    Section.send_video_notifications
    if Date.today.friday?
      Section.send_office_hours_reminders
    end
  end

  desc 'Send workshop surveys for current sections that are ending'
  task surveys: :environment do
    Section.send_surveys
  end

  desc 'Send welcome emails to those who subscribed to prime in the last 24 hours'
  task prime_welcome: :environment do
    Subscription.deliver_welcome_emails
  end

  desc 'Send notifications for published bytes'
  task bytes: :environment do
    Subscription.deliver_byte_notifications
  end
end
