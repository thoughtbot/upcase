
# Video.order(:published_on).last(5).each do |video|
#   RecommendableContent.create(recommendable: video)
# end

def user_has_seen_video(user, video)
  video.statuses.where(user: user).any?
end

def has_seen_all_recommendables(user, recommendables)
  !recommendables.reject do |video|
    user_has_seen_video(user, video)
  end.any?
end

subscribers_to_email.select do |user|
  has_seen_all_recommendables(user, recoms)
end.map(&:email)

have_watched_all = _
have_watched_all.first

recoms.reject do |video|
  video.statuses.where(user: user).any?
end


recoms = RecommendableContent.all.map(&:recommendable);nil

recoms.map do |video|
  [video.slug, video.statuses.where(user: subscribers_to_email).map(&:user).uniq.count]
end

have_seen_all = [12401, 15742, 4631]

videos = [
  'regular-expressions',
  "tell-don-t-ask",
  "composition-over-inheritance",
  'enumerable-and-comparable',
  "optimizing-sql-queries-in-postgres",
].map do |slug|
  Video.find_by(slug: slug)
end;nil
subscribers_to_email.reject do |user|
  have_seen_all.include?(user.id) ||
  videos.reject do |video|
    user_has_seen_video(user, video)
  end.any?
end.map(&:email)


recoms.select do |video|
  video.statuses.where(user: dem).none?
end.map(&:slug)

recommendables = RecommendableContent.priority_ordered;nil
subscribers_to_email = ActiveSubscribers.new.reject(&:unsubscribed_from_emails?);nil

next_up_for_user(subscribers_to_email.first, recommendables)

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
