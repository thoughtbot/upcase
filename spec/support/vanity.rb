module VanityHelpers
  def vanity_signup_count
    tracked_events_for(Vanity.playground.metric(:signups))
  end

  def tracked_events_for(metric)
    events_from_today =
      Vanity::Metric.data(metric, Date.today, Date.today).first
    count_of_todays_events = events_from_today.second
  end

  def stub_ab_test_result(experiment, choice)
    Vanity.playground.experiment(experiment).identify {}
    Vanity.playground.experiment(experiment).chooses(choice)
  end
end
