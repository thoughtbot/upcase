namespace :reminders do
  desc 'Send reminders for sections a week from now'
  task :section do
    Section.send_reminders
  end
end
