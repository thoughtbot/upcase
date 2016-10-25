require "rails_helper"

describe WeeklyIterationDripMailer do
  describe "#weekly_update" do
    it "comes from Ben Orenstein" do
      message = build_message

      expect(message).
        to deliver_from("Ben from thoughtbot <ben@thoughtbot.com>")
    end

    it "replies to the generic Upcase email" do
      message = build_message

      expect(message).to reply_to("help@upcase.com")
    end

    it "delivers to the specified user's email" do
      email = "whatevs@example.com"
      user = build(:user, email: email)

      message = build_message(user: user)

      expect(message).to deliver_to(email)
    end

    it "contains the phrase `Classic Weekly Iteration` in the subject field"

    it "contains a link to the specified Weekly Iteration" do
      slug = "ruby-like-a-boss"
      video = build(:video, slug: slug)

      message = build_message(video: video)

      expect(message).to have_body_text(slug)
    end

    it "contains a quippy summary of the video" do
      video = build(:video, slug: slug)
      video.email_subject_line
      video.email_body_text #markdown
      video.button_cta
    end
  end

  def build_message(user: build_stubbed(:user), video: build_stubbed(:video))
    WeeklyIterationDripMailer.weekly_update(user: user, video: video)
  end
end
