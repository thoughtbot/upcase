namespace :weekly_iteration_suggestions do
  desc "Enqueues email jobs for every acrtive subscriber with recommendable TWI episodes to watch"
  task send: :environment do
    if Time.current.tuesday?
      subscribers = ActiveSubscribers.new.reject(&:unsubscribed_from_emails)
      WeeklyIterationSuggestions.new(subscribers).send
    end
  end
end
