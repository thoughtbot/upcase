class WeeklyIterationDripMailerPreview < ActionMailer::Preview
  def weekly_update
    user = User.new(name: 'John Doe')
    video = Video.first.tap do |video|
      video.email_body_text = 'Email body text'
      video.email_cta_label = 'Click Here!'
    end

    WeeklyIterationDripMailer.weekly_update(user: user, video: video)
  end
end
