class WeeklyIterationMailerJob < ApplicationJob
  include ErrorReporting

  def perform(user_id, video_id)
    @user_id = user_id
    @video_id = video_id

    send_weekly_iteration_mailer
  end

  private

  attr_reader :user_id, :video_id

  def send_weekly_iteration_mailer
    WeeklyIterationDripMailer.
      weekly_update(user: user, video: video).
      deliver_now
  end

  def user
    User.find user_id
  end

  def video
    Video.find video_id
  end
end
