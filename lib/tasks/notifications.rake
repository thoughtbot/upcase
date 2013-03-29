namespace :notifications do
  desc 'Send notifications for current sections'
  task section: :environment do
    Section.send_notifications
  end

  desc 'Send welcome emails to those who subscribed to prime in the last 24 hours'
  task prime_welcome: :environment do
    Subscription.deliver_welcome_emails
  end
end
