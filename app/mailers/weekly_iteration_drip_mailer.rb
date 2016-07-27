class WeeklyIterationDripMailer < ActionMailer::Base
  default from: "Ben from thoughtbot <ben@thoughtbot.com>".freeze,
    reply_to: "help@upcase.com"

  def weekly_update(user:, video:)
    @video = video
    mail to: user.email
  end
end
