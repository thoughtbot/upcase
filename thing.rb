


recommendable_weekly_iterations = RecommendableContent.
  from_the_weekly_iteration.
  priority_ordered

subscribers_to_email = ActiveSubscribers.new.reject(&:unsubscribed_from_emails?)

subscribers_to_email.each do |subscriber|
  previously_recommended = ContentRecommendation.where(user: user)

  suggestor = ContentSuggestor.new(
    user: subscriber,
    recommendables: recommendable_weekly_iterations,
    previously_recommended: previously_recommended
  )

  suggestor.next_up.present do |video|
    WeeklyIterationMailer.
      weekly_update(user: subscriber, video: video).
      send_later
    ContentRecommendation.create!(user: user, recommendable: video)
  end.blank do
    Rails.logger.warn "No further recommendable videos for user: #{user.id} <#{user.email}>"
  end
end

# with_active_subscription
# Recommendation.for
# updte next_weekly_iteration to account for recommended
# build mailer
# Make ContentSequence a model which stores the iteration sequence
# handle unsubscribes (can add 'unsubscribed_from_emails': true to identify # hash)
