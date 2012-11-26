require 'spec_helper'

describe Mailer do
  describe '.purchase_receipt' do
    include Rails.application.routes.url_helpers

    context 'for a purchase without a user' do
      let(:purchase) do
        create :purchase, :created_at => Time.now, :email => 'joe@example.com',
          :lookup => 'asdf', :name => 'Joe Smith'
      end

      before do
        @email = Mailer.purchase_receipt(purchase)
      end

      it 'is to the email passed in' do
        @email.should deliver_to(purchase.email)
      end

      it 'contains the name in the mail body' do
        @email.should have_body_text(/#{purchase.name}/)
      end

      it 'contains the price of the purchase' do
        @email.should have_body_text(/\$#{purchase.price}\.00/)
      end

      it 'should have the correct subject' do
        @email.should have_subject(/Your receipt for #{purchase.product.name}/)
      end

      it 'contains a link to create a new account in the body' do
        @email.should have_body_text(/#{new_user_url(host: HOST)}/)
      end
    end

    context 'for a purchase with a user' do
      let(:purchase) do
        create :purchase, user: create(:user)
      end

      before do
        @email = Mailer.purchase_receipt(purchase)
      end

      it 'does not contain a link to create a new account in the body' do
        @email.should_not have_body_text(/#{new_user_url(host: HOST)}/)
      end
    end

    context 'for a product with an announcement' do
      it 'contains announcement.message in the body' do
        purchase = create(:purchase)
        announcement = create(:announcement, announceable: purchase.product)
        email = Mailer.purchase_receipt(purchase)
        expect(email).to have_body_text(/#{announcement.message}/)
      end
    end
  end

  describe '.registration_confirmation' do
    include Rails.application.routes.url_helpers

    context 'for a registration without a user' do
      let(:registration) do
        create :registration, :email => 'joe@example.com'
      end

      before do
        @email = Mailer.registration_confirmation(registration)
      end

      it 'contains a link to create a new account in the body' do
        @email.should have_body_text(/#{new_user_url(host: HOST)}/)
      end
    end

    context 'for a registration with a user' do
      let(:registration) do
        create :registration, user: create(:user)
      end

      before do
        @email = Mailer.registration_confirmation(registration)
      end

      it 'does not contain a link to create a new account in the body' do
        @email.should_not have_body_text(/#{new_user_url(host: HOST)}/)
      end
    end

    context 'for a course with an announcement' do
      it 'contains announcement.message in the body' do
        registration = create(:registration)
        course = registration.section.course
        announcement = create(:announcement, announceable: course)
        email = Mailer.registration_confirmation(registration)
        expect(email).to have_body_text(/#{announcement.message}/)
      end
    end
  end

  describe '.section_reminder' do
    let(:course_name) do
      'Hilarious Backbone.js'
    end

    let(:recipient) do
      'frankie-z@example.com'
    end

    let(:sent_email) do
      course = create(:course, name: course_name)
      section = create(:section, course: course)

      registration = create(:registration,
                            section: section,
                            email: recipient,
                            first_name: 'Benny',
                            last_name: 'Burns')

      Mailer.section_reminder registration, section
    end

    it 'has the correct subject' do
      sent_email.subject.should =~ /#{course_name}/
    end

    it 'has the correct recipient' do
      sent_email.to.should include(recipient)
    end

    it "has the registrant's name in the body" do
      sent_email.body.should include('Benny Burns')
    end
  end

  describe '.fulfillment_error' do
    it 'sets the correct recipients' do
      purchase = stubbed_purchase
      mailer = Mailer.fulfillment_error(purchase, github_username)

      mailer.should deliver_to(purchase.email)
      mailer.should cc_to('learn@thoughtbot.com')
      mailer.should reply_to('learn@thoughtbot.com')
    end

    it 'sets the correct subject' do
      purchase = stubbed_purchase
      mailer = Mailer.fulfillment_error(purchase, github_username)

      mailer.should have_subject("Fulfillment issues with #{purchase.product_name}")
    end

    it 'sets the username in the message body' do
      mailer = Mailer.fulfillment_error(stubbed_purchase, github_username)

      mailer.should have_body_text(/#{github_username}/)
    end
  end

  private

  def github_username
    'github_username'
  end

  def stubbed_purchase
    stub(
      product_name: 'Backbone.js on Rails',
      name: 'Benny Burns',
      email: 'benny@theburns.org'
    )
  end
end
