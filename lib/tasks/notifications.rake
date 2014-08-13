namespace :notifications do
  desc 'Send welcome emails to those who subscribed to upcase in the last 24 hours'
  task upcase_welcome: :environment do
    Subscription.deliver_welcome_emails
  end
end
