require "rails_helper"

describe SubscriptionMailer do
  describe ".subscription_receipt" do
    include Rails.application.routes.url_helpers

    it "is sent to the given email" do
      expect(subscription_receipt_email.to).to eq(%w(email@example.com))
    end

    it "includes the billed amount as currency" do
      expect(subscription_receipt_email).to have_body_text(/\$99.00/)
    end

    it "mentions the referral program" do
      percent_off = "50"

      ClimateControl.modify REFERRAL_DISCOUNT: percent_off do
        expect(subscription_receipt_email).
          to have_body_text("#{percent_off}% off")
      end
    end

    it "includes a link to the invoice" do
      expect(subscription_receipt_email).to have_body_text(
        subscriber_invoice_url("invoice_id")
      )
    end

    it "is sent from upcase" do
      expect(subscription_receipt_email.from).to include(ENV["SUPPORT_EMAIL"])
    end

    it "specifies the subject" do
      expect(subscription_receipt_email.subject).to eq(
        I18n.t("mailers.subscription.subscription_receipt.subject")
      )
    end

    it "links to the forum" do
      expect(subscription_receipt_email).
        to(have_body_text("https://forum.upcase.com"))
    end

    def subscription_receipt_email
      SubscriptionMailer.subscription_receipt(
        "email@example.com",
        99,
        "invoice_id"
      )
    end
  end

  describe ".upcoming_payment_notification" do
    include Rails.application.routes.url_helpers

    it "is sent to the given email" do
      expect(upcoming_payment_notification_email.to).to eq ["email@example.com"]
    end

    it "is sent from upcase" do
      expect(upcoming_payment_notification_email.from).to include ENV["SUPPORT_EMAIL"]
    end

    it "mentions the referral program" do
      expect(upcoming_payment_notification_email).to have_body_text("50% off")
    end

    it "includes a link to account page" do
      expect(upcoming_payment_notification_email).to have_body_text(my_account_url)
    end

    it "includes a correct plan name" do
      expect(upcoming_payment_notification_email).to have_body_text("Individual")
    end

    it "includes the next billing date" do
      expect(upcoming_payment_notification_email).to have_body_text("2014-01-01")
    end

    it "includes the next payment amount" do
      amount_in_cents = 1999
      subscription = build_subscription(next_payment_amount: amount_in_cents)

      result = upcoming_payment_notification_email(subscription)

      expect(result).to have_body_text("$19.99")
    end

    it "specifies the subject" do
      expect(upcoming_payment_notification_email.subject).to eq(
        I18n.t("mailers.subscription.upcoming_payment_notification.subject")
      )
    end

    def upcoming_payment_notification_email(subscription = nil)
      subscription = subscription || build_subscription
      allow(subscription).to receive(:plan_name).and_return("Individual")

      SubscriptionMailer.upcoming_payment_notification(subscription)
    end

    def build_subscription(attributes = {})
      user = build_user
      build_stubbed(
        :subscription,
        {
          next_payment_on: Date.parse("2014-01-01"),
          user: user
        }.merge(attributes)
      )
    end

    def build_user
      build_stubbed(:user, email: "email@example.com")
    end
  end
end
