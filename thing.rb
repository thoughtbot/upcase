
# Video.order(:published_on).last(5).each do |video|
#   RecommendableContent.create(recommendable: video)
# end




recommendable_weekly_iterations = RecommendableContent.priority_ordered;nil


subscribers_to_email = ActiveSubscribers.new.reject(&:unsubscribed_from_emails?);nil

def next_up_for_user(user, recommendables)
  ContentSuggestor.new(
    user: user,
    recommendables: recommendables.map(&:recommendable),
    recommended: ContentRecommendation.where(user: user).map(&:recommendable),
  ).next_up
end

dem = subscribers_to_email.map do |user|
  next_up = next_up_for_user(user, recommendable_weekly_iterations).present do |video|
    video.slug
  end.blank { "NONE FOUND" }
  [next_up.unwrap, "#{user.email} [#{user.id}]"]
end

user = User.find_by email: 'chris@thoughtbot.com'
video = Video.last

WeeklyIterationDripMailer.delay(run_at: Date.tomorrow).weekly_update(
  user: user,
  video: video,
)

# Pick the top 52
# Want 90% of active users to have 26+ weeks in the can

# subscribers_to_email.each do |subscriber|
#   previously_recommended = ContentRecommendation.where(user: subscriber)

#   suggestor = ContentSuggestor.new(
#     user: subscriber,
#     recommendables: recommendable_weekly_iterations,
#     recommended: previously_recommended
#   )

#   suggestor.next_up.present do |video|
#     # index = videos.index(video)
#     # puts [index, subscriber.id, subscriber.email].to_s
#   end.blank do
#     puts [:nil, subscriber.id, subscriber.email].to_s
#   end

#   # suggestor.next_up.present do |video|
#   #   WeeklyIterationMailer.
#   #     weekly_update(user: subscriber, video: video).
#   #     send_later
#   #   ContentRecommendation.create!(user: user, recommendable: video)
#   # end.blank do
#   #   Rails.logger.warn "No further recommendable videos for user: #{user.id} <#{user.email}>"
#   # end
# end;nil

# include ActionView::Helpers::NumberHelper

# def percentage_watched_for(user, videos)
#   watched_videos = videos.select { |v| v.statuses.where(user: user).any? }
#   watched_videos.count.to_f / videos.count
# end


# percents = subscribers_to_email.map do |user|
#   (percentage_watched_for(user, wi_videos) * 100).to_i
# end

# counts = (0..100).map do |i|
#   percents.count { |p| p == i }
# end

# CSV.open("./counts.csv", "w") { |csv| csv << counts }


# with_active_subscription
# Recommendation.for
# updte next_weekly_iteration to account for recommended
# build mailer
# Make ContentSequence a model which stores the iteration sequence
# handle unsubscribes (can add 'unsubscribed_from_emails': true to identify # hash)
