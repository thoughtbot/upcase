namespace :weekly_iteration_suggestions do
  desc "Enqueues email jobs for every acrtive subscriber with recommendable TWI episodes to watch"
  task send: :environment do
    WeeklyIterationSuggestions.new(ActiveSubscribers.new).send
  end
end
