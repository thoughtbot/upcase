require "rails_helper"

describe CheckoutMailer do
  describe ".receipt" do
    include Rails.application.routes.url_helpers

    context "for user who has a subscription" do
      describe "for a subscription product" do
        it "includes support" do
          checkout = create(:checkout)

          expect(email_for(checkout)).to have_body_text(/support/)
        end

        it "has a thank you for subscribing" do
          checkout = create(:checkout)

          expect(email_for(checkout)).to have_body_text(/Thank you for subscribing/)
        end

        it "mentions the mentor email" do
          checkout = create(:checkout, plan: create(:plan, :includes_mentor))

          expect(email_for(checkout)).to have_body_text(/mentor/)
        end

        it "does not mention the features the user does not have" do
          checkout = create(:checkout, plan: create(:basic_plan))

          expect(email_for(checkout)).not_to have_body_text(/mentor/)
          expect(email_for(checkout)).not_to have_body_text(/video_tutorials/)
        end
      end
    end

    def expect_to_contain_receipt(checkout)
      expect(email_for(checkout)).to have_body_text(/RECEIPT/)
    end

    def expect_not_to_contain_receipt(checkout)
      expect(email_for(checkout)).not_to have_body_text(/RECEIPT/)
    end

    def email_for(checkout)
      CheckoutMailer.receipt("basic@exmaple.com", checkout.plan.id)
    end
  end
end
