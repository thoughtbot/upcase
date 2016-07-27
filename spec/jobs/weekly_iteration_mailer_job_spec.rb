require "rails_helper"

describe WeeklyIterationMailerJob do
  it_behaves_like "a Delayed Job that notifies Honeybadger about errors"

  describe "#perform" do
    it "sends an email to specified user for the video" do
      user = create(:user)
      video = create(:video)
      mailer_stub = stub_mail_method(WeeklyIterationDripMailer, :weekly_update)

      WeeklyIterationMailerJob.perform_later(user.id, video.id)

      expect(WeeklyIterationDripMailer).to have_received(:weekly_update).with(
        user: user,
        video: video,
      )
      expect(mailer_stub).to have_received(:deliver_now)
    end
  end
end
