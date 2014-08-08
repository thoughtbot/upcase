require "rails_helper"

describe CheckoutMailer do
  describe '.receipt' do
    include Rails.application.routes.url_helpers

    context 'for user who has a subscription' do
      describe 'for a subscription product' do
        it 'includes support' do
          user = create(:subscriber)
          checkout = create(:checkout, user: user)

          expect(email_for(checkout)).to have_body_text(/support/)
        end

        it 'has a thank you for subscribing' do
          user = create(:subscriber)
          checkout = create(:checkout, user: user)

          expect(email_for(checkout)).to have_body_text(/Thank you for subscribing/)
        end

        it 'mentions the mentor email' do
          plan = create(:individual_plan, :includes_mentor)
          user = create(:subscriber, plan: plan)
          checkout = create(:checkout, user: user, subscribeable: plan)

          expect(email_for(checkout)).to have_body_text(/mentor/)
        end

        it 'does not mention the features the user does not have' do
          user = create(:subscriber)
          checkout = create(
            :checkout,
            user: user,
            subscribeable: create(:basic_plan)
          )

          expect(email_for(checkout)).not_to have_body_text(/mentor/)
          expect(email_for(checkout)).not_to have_body_text(/workshops/)
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
      CheckoutMailer.receipt(checkout)
    end

    def checkout
      @checkout ||= create(:checkout, created_at: Time.zone.now, email: 'joe@example.com',
                           lookup: 'asdf', name: 'Joe Smith')
    end
  end
end
