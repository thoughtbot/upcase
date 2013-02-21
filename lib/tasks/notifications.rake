namespace :notifications do
  desc 'Send notifications for current sections'
  task section: :environment do
    Section.send_notifications
  end
end
