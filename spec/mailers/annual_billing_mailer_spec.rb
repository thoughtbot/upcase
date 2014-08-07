require "rails_helper"

describe AnnualBillingMailer do
  describe ".notification" do
    it "notifies the Upcase team of a user's intent to upgrade" do
      user = build_stubbed(:user)

      mail = AnnualBillingMailer.notification(user)

      expect(mail.to).to include(ENV["SUPPORT_EMAIL"])
      expect(mail).to have_body_text(user.email)
      expect(mail.subject).to eq("Annual upgrade notification")
    end
  end
end
