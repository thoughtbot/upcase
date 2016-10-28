class WeeklyIterationDripMailer < ActionMailer::Base
  include ApplicationHelper
  include UnsubscribesHelper

  default(
    from: ENV.fetch("WEEKLY_ITERATION_DRIP_MAILER_FROM"),
    reply_to: ENV.fetch("SUPPORT_EMAIL"),
  )

  def weekly_update(user:, video:)
    @html_content = format_markdown(video.email_body_text)
    @unsubscribe_token = unsubscribe_token_verifier.generate(user.id)
    @user = user
    @video = video
    @utm_params = {
      utm_campaign: "#{video.slug}-weekly-drip",
      utm_medium: "email",
    }

    mail(
      to: user.email,
      subject: @video.email_subject,
    )
  end
end
