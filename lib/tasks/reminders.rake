namespace :reminders do
  desc 'Send reminders for sections a week from now'
  task section: :environment do
    Section.send_reminders
  end
end
