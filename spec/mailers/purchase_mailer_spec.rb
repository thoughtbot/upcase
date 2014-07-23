require 'spec_helper'

describe PurchaseMailer do
  describe '.fulfillment_error' do
    it 'sets the correct recipients' do
      purchase = stubbed_purchase
      mailer = PurchaseMailer.fulfillment_error(purchase, github_username)

      expect(mailer).to deliver_to(purchase.email)
      expect(mailer).to cc_to('learn@thoughtbot.com')
      expect(mailer).to reply_to('learn@thoughtbot.com')
    end

    it 'sets the correct subject' do
      purchase = stubbed_purchase
      mailer = PurchaseMailer.fulfillment_error(purchase, github_username)

      expect(mailer).to have_subject(
        "Fulfillment issues with #{purchase.purchaseable_name}")
    end

    it 'sets the username in the message body' do
      mailer = PurchaseMailer.fulfillment_error(stubbed_purchase, github_username)

      expect(mailer).to have_body_text(/#{github_username}/)
    end

    def github_username
      'github_username'
    end

    def stubbed_purchase
      stub(
        purchaseable_name: 'Backbone.js on Rails',
        name: 'Benny Burns',
        email: 'benny@theburns.org'
      )
    end
  end

  describe '.purchase_receipt' do
    include Rails.application.routes.url_helpers

    context 'for a workshop purchase' do
      it 'does not contain text about downloading' do
        purchase = create_subscriber_purchase(:workshop)
        email = email_for(purchase)

        expect(email).not_to have_body_text(/download/)
      end

      context 'with an announcement' do
        it 'contains announcement.message in the body' do
          purchase = create_subscriber_purchase(:workshop)
          workshop = purchase.purchaseable
          announcement = create(:announcement, announceable: workshop)
          email = email_for(purchase)

          expect(email).to have_body_text(/#{announcement.message}/)
        end
      end
    end

    context 'for a non-workshop purchase' do
      it 'does contain text about downloading' do
        purchase = create(:book_purchase)
        email = email_for(purchase)

        expect(email).to have_body_text(/download/)
      end
    end

    context 'for a purchase without a user' do
      it 'is to the email passed in' do
        expect(email_for(purchase)).to deliver_to(purchase.email)
      end

      it 'contains the name in the mail body' do
        expect(email_for(purchase)).to have_body_text(/#{purchase.name}/)
      end

      it 'contains the price of the purchase' do
        expect(email_for(purchase)).to have_body_text(/\$#{purchase.price.to_i}\.00/)
      end

      it 'should have the correct subject' do
        expect(email_for(purchase)).to have_subject(/Your receipt for #{purchase.purchaseable_name}/)
      end

      it 'contains a link to create a new account in the body' do
        expect(email_for(purchase)).to(
          have_body_text(/#{new_user_url(host: ENV['APP_DOMAIN'])}/)
        )
      end
    end

    context 'for a purchase with a user' do
      it 'does not contain a link to create a new account in the body' do
        purchase = create(:purchase, user: create(:user))

        expect(email_for(purchase)).not_to(
          have_body_text(/#{new_user_url(host: ENV['APP_DOMAIN'])}/)
        )
      end
    end

    context 'for a product with an announcement' do
      it 'contains announcement.message in the body' do
        purchase = create(:purchase)
        announcement = create(:announcement, announceable: purchase.purchaseable)

        expect(email_for(purchase)).to have_body_text(/#{announcement.message}/)
      end
    end

    context 'for user who has a subscription' do
      context 'for a non-subscription product' do
        it 'does not contain the receipt' do
          user = create(:subscriber)
          purchase = create(:book_purchase, user: user)

          expect_not_to_contain_receipt(purchase)
        end

        it 'does not include support' do
          user = create(:subscriber)
          purchase = create(:book_purchase, user: user)

          expect(email_for(purchase)).not_to have_body_text(/support/)
        end
      end

      describe 'for a subscription product' do
        it 'does contain the receipt' do
          user = create(:subscriber)
          purchase = create(:plan_purchase, user: user)

          expect_to_contain_receipt(purchase)
        end

        it 'includes support' do
          user = create(:subscriber)
          purchase = create(:plan_purchase, user: user)

          expect(email_for(purchase)).to have_body_text(/support/)
        end

        it 'has a thank you for subscribing' do
          user = create(:subscriber)
          purchase = create(:plan_purchase, user: user)

          expect(email_for(purchase)).to have_body_text(/Thank you for subscribing/)
        end

        it 'mentions the mentor email' do
          plan = create(:individual_plan, :includes_mentor)
          user = create(:subscriber, plan: plan)
          purchase = create(:plan_purchase, user: user, purchaseable: plan)

          expect(email_for(purchase)).to have_body_text(/mentor/)
        end

        it 'does not mention the features the user does not have' do
          user = create(:subscriber)
          purchase = create(
            :plan_purchase,
            user: user,
            purchaseable: create(:basic_plan)
          )

          expect(email_for(purchase)).not_to have_body_text(/mentor/)
          expect(email_for(purchase)).not_to have_body_text(/workshops/)
        end
      end
    end

    context 'for user who does not have a subscription' do
      it 'does contain the receipt' do
        user = create(:user)
        purchase = create(:book_purchase, user: user)

        expect_to_contain_receipt(purchase)
      end
    end

    context 'for a purchase with no user' do
      it 'does contain the receipt' do
        purchase = create(:book_purchase, user: nil)

        expect_to_contain_receipt(purchase)
      end
    end

    def expect_to_contain_receipt(purchase)
      expect(email_for(purchase)).to have_body_text(/RECEIPT/)
    end

    def expect_not_to_contain_receipt(purchase)
      expect(email_for(purchase)).not_to have_body_text(/RECEIPT/)
    end

    def email_for(purchase)
      PurchaseMailer.purchase_receipt(purchase)
    end

    def purchase
      @purchase ||= create(:purchase, created_at: Time.zone.now, email: 'joe@example.com',
                           lookup: 'asdf', name: 'Joe Smith')
    end
  end
end
