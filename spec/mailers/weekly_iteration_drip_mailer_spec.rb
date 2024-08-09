require "rails_helper"

describe WeeklyIterationDripMailer do
  describe "#weekly_update" do
    it "comes from Ben Orenstein" do
      message = build_message

      expect(message)
        .to deliver_from("Ben from thoughtbot <ben@thoughtbot.com>")
    end

    it "replies to the generic Upcase email" do
      message = build_message

      expect(message).to reply_to(ENV.fetch("SUPPORT_EMAIL"))
    end

    it "delivers to the specified user's email" do
      email = "whatevs@example.com"
      user = build(:user, email: email)

      message = build_message(user: user)

      expect(message).to deliver_to(email)
    end

    it "contains the video's email subject in the subject field" do
      subject = "Weekly Iteration: Ruby like a boss"
      video = build_stubbed(:video, email_subject: subject)

      message = build_message(video: video)

      expect(message).to have_subject(video.email_subject)
    end

    it "contains a link to the specified Weekly Iteration" do
      slug = "ruby-like-a-boss"
      video = build(:video, slug: slug)

      message = build_message(video: video)

      expect(message).to have_body_text(slug)
      expect(message).to have_body_text("utm_medium=email")
      expect(message).to have_body_text(
        "utm_campaign=#{video.slug}-weekly-drip"
      )
    end

    it "renders markdown" do
      video = build_stubbed(:video, email_body_text: "The **body**")

      message = build_message(video: video)

      expect(message).to have_body_text("The <strong>body</strong>")
    end

    it "contains a summary and CTA of the video" do
      video = build_stubbed(
        :video,
        email_cta_label: "The CTA",
        email_body_text: "The body"
      )

      message = build_message(video: video)

      expect(message).to have_body_text("The CTA")
      expect(message).to have_body_text("The body")
      expect(message).to have_body_text("unsubscribe")
    end
  end

  def build_message(user: build_stubbed(:user), video: build_stubbed(:video))
    WeeklyIterationDripMailer.weekly_update(user: user, video: video)
  end
end
