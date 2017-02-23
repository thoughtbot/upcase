require "rails_helper"

RSpec.describe PauseMailer, type: :mailer do
  describe ".pause" do
    include Rails.application.routes.url_helpers

    let(:last_billing_date) do
      Time.zone.at(FakeStripe::SUBSCRIPTION_BILLING_PERIOD_END)
    end
    let(:reactivation_date) { last_billing_date + 90.days }
    let(:subscription) { build_stubbed(:subscription) }
    let(:email) { PauseMailer.pause(subscription) }

    it "verifies the pausing" do
      expect(email).to have_body_text(/paused/)
    end

    it "includes date their last billing date is" do
      formatted_last_billing_date = last_billing_date.strftime("%B %e")

      expect(email).to have_body_text(formatted_last_billing_date)
    end

    it "includes date the subscription will restart" do
      restart_date = "Monday, May 20"

      expect(email).to have_body_text(restart_date)
    end

    it "includes link to the 'my account' page" do
      expect(email).to have_body_text(my_account_url)
    end
  end

  describe ".pre_notification" do
    it "tells user that a new subscription is about to start" do
      subscription = build_stubbed(:inactive_subscription)
      email = PauseMailer.pre_notification(subscription)

      expect(email).to have_body_text(/about to restart/)
    end

    it "includes the day of the week that it will be restarted" do
      subscription = build_stubbed(:inactive_subscription)
      email = PauseMailer.pre_notification(subscription)
      day_of_the_week = 2.days.from_now.strftime("%A")

      expect(email).to have_body_text(day_of_the_week)
    end

    it "includes the date that the pause occured" do
      cancel_date = 90.days.ago
      month_and_day_format = "%B %-e"
      formatted_date = cancel_date.strftime(month_and_day_format)
      subscription = build_stubbed(
        :inactive_subscription,
        user_clicked_cancel_button_on: cancel_date,
      )
      email = PauseMailer.pre_notification(subscription)

      expect(email).to have_body_text(formatted_date)
    end
  end

  describe ".restarted" do
    let(:email) { PauseMailer.restarted(build_stubbed(:subscription)) }

    it "tells user that a new subscription just started" do
      expect(email).to have_body_text(/subscription has been restarted/)
    end

    it "includes links to trails, weekly iterations, forum, etc" do
      expect(email).to have_body_text(practice_url)
      expect(email).to have_body_text("https://forum.upcase.com")
      expect(email).to have_body_text(show_url("the-weekly-iteration"))
    end
  end
end
