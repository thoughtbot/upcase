require 'spec_helper'

describe Mailer do
  describe '.follow_up' do
    include Rails.application.routes.url_helpers

    it "mentions the workshop name" do
      workshop = create(:workshop, name: "Foo bar")

      expect(follow_up_for(workshop: workshop).body).to include "Foo bar"
    end

    it "is from learn@thoughtbot.com" do
      expect(follow_up_for.from).to eq(%w(learn@thoughtbot.com))
    end

    it "mentions the workshop name in the subject" do
      workshop = create(:workshop, name: "Foo bar")

      expect(follow_up_for(workshop: workshop).subject).to include "Foo bar"
    end

    it "is sent to the follow up email" do
      follow_up = create(:follow_up)

      expect(follow_up_for(follow_up: follow_up).to).to eq([follow_up.email])
    end

    it "links to the workshop" do
      workshop = create(:workshop)

      expect(follow_up_for(workshop: workshop).body).to include workshop_url(workshop)
    end

    def follow_up_for(options = {})
      options[:follow_up] ||= create(:follow_up)
      options[:workshop] ||= create(:workshop)
      section = create(:section, workshop: options[:workshop])

      Mailer.follow_up options[:follow_up], section
    end
  end

  describe '.fulfillment_error' do
    it 'sets the correct recipients' do
      purchase = stubbed_purchase
      mailer = Mailer.fulfillment_error(purchase, github_username)

      expect(mailer).to deliver_to(purchase.email)
      expect(mailer).to cc_to('learn@thoughtbot.com')
      expect(mailer).to reply_to('learn@thoughtbot.com')
    end

    it 'sets the correct subject' do
      purchase = stubbed_purchase
      mailer = Mailer.fulfillment_error(purchase, github_username)

      expect(mailer).to have_subject(
        "Fulfillment issues with #{purchase.purchaseable_name}")
    end

    it 'sets the username in the message body' do
      mailer = Mailer.fulfillment_error(stubbed_purchase, github_username)

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
        purchase = create(:section_purchase)
        email = email_for(purchase)

        expect(email).not_to have_body_text(/download/)
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
        expect(email_for(purchase)).to have_body_text(/\$#{purchase.price}\.00/)
      end

      it 'should have the correct subject' do
        expect(email_for(purchase)).to have_subject(/Your receipt for #{purchase.purchaseable_name}/)
      end

      it 'contains a link to create a new account in the body' do
        expect(email_for(purchase)).to have_body_text(/#{new_user_url(host: HOST)}/)
      end
    end

    context 'for a purchase with a user' do
      it 'does not contain a link to create a new account in the body' do
        purchase = create(:purchase, user: create(:user))

        expect(email_for(purchase)).not_to have_body_text(/#{new_user_url(host: HOST)}/)
      end
    end

    context 'for a product with an announcement' do
      it 'contains announcement.message in the body' do
        purchase = create(:purchase)
        announcement = create(:announcement, announceable: purchase.purchaseable)

        expect(email_for(purchase)).to have_body_text(/#{announcement.message}/)
      end
    end

    def email_for(purchase)
      Mailer.purchase_receipt(purchase)
    end

    def purchase
      @purchase ||= create(:purchase, created_at: Time.now, email: 'joe@example.com',
        lookup: 'asdf', name: 'Joe Smith')
    end
  end

  describe '.registration_confirmation' do
    include Rails.application.routes.url_helpers

    context 'for a registration without a user' do
      it 'contains a link to create a new account in the body' do
        purchase = create(:section_purchase, email: 'joe@example.com')
        email = Mailer.registration_confirmation(purchase)

        expect(email).to have_body_text(/#{new_user_url(host: HOST)}/)
      end
    end

    context 'for a registration with a user' do
      it 'does not contain a link to create a new account in the body' do
        purchase = create :section_purchase, user: create(:user)
        email = Mailer.registration_confirmation(purchase)

        expect(email).not_to have_body_text(/#{new_user_url(host: HOST)}/)
      end
    end

    context 'for a workshop with an announcement' do
      it 'contains announcement.message in the body' do
        purchase = create(:section_purchase)
        workshop = purchase.purchaseable.workshop
        announcement = create(:announcement, announceable: workshop)
        email = Mailer.registration_confirmation(purchase)

        expect(email).to have_body_text(/#{announcement.message}/)
      end
    end

    context 'for an online workshop' do
      it 'does not contain a section about comments or dietary restrictions' do
        purchase = create(:online_section_purchase, comments: 'comments and requests')
        email = Mailer.registration_confirmation(purchase)

        expect(email).not_to have_body_text(/following comments|dietary restrictions/)
      end
    end

    context 'for an in-person workshop' do
      it 'does not contain a section about comments or dietary restrictions' do
        purchase = create(:in_person_section_purchase, comments: 'comments and requests')
        email = Mailer.registration_confirmation(purchase)

        expect(email).to have_body_text(/following comments|dietary restrictions/)
      end
    end
  end

  describe '.registration_notification' do
    it 'includes starts_on and ends_on in the email body' do
      Timecop.freeze Date.parse('2012-09-12') do
        purchase = build_stubbed(:section_purchase)
        email = Mailer.registration_notification(purchase)

        expect(email.body).to include purchase.purchaseable.date_range
      end
    end

    it 'includes section city in the email body' do
      Timecop.freeze Date.parse('2012-09-12') do
        purchase = build_purchase_in 'San Antonio'
        email = Mailer.registration_notification(purchase)

        expect(email.body).to include 'San Antonio'
      end
    end

    context 'for an online workshop' do
      it 'does not contain a section about comments or dietary restrictions' do
        purchase = create(:online_section_purchase, comments: 'comments and requests')
        email = Mailer.registration_notification(purchase)

        expect(email).not_to have_body_text(/Comments:/)
      end
    end

    context 'for an in-person workshop' do
      it 'does not contain a section about comments or dietary restrictions' do
        purchase = create(:in_person_section_purchase, comments: 'comments and requests')
        email = Mailer.registration_notification(purchase)

        expect(email).to have_body_text(/Comments:/)
      end
    end

    def build_purchase_in(city)
      build_stubbed(:section_purchase).tap do |purchase|
        purchase.purchaseable.city = city
      end
    end
  end

  describe '.section_reminder' do
    it 'has the correct subject' do
      expect(sent_email.subject).to match(/#{workshop_name}/)
    end

    it 'has the correct recipient' do
      expect(sent_email.to).to include(recipient)
    end

    it "has the registrant's name in the body" do
      expect(sent_email.body).to include('Benny Burns')
    end

    context 'for an online workshop' do
      it 'does not contain a section about comments or dietary restrictions' do
        purchase = create(:online_section_purchase, comments: 'comments and requests')
        section = purchase.purchaseable
        email = Mailer.section_reminder(purchase.id, section.id)

        expect(email).not_to have_body_text(/following comments|dietary restrictions/)
      end
    end

    context 'for an in-person workshop' do
      it 'does not contain a section about comments or dietary restrictions' do
        purchase = create(:in_person_section_purchase, comments: 'comments and requests')
        section = purchase.purchaseable
        email = Mailer.section_reminder(purchase.id, section.id)

        expect(email).to have_body_text(/following comments|dietary restrictions/)
      end
    end

    def workshop_name
      'Hilarious Backbone.js'
    end

    def recipient
      'frankie-z@example.com'
    end

    def sent_email
      workshop = create(:workshop, name: workshop_name)
      section = create(:section, workshop: workshop)

      purchase = create(:purchase,
                        purchaseable: section,
                        email: recipient,
                        name: 'Benny Burns')

      Mailer.section_reminder(purchase, section)
    end
  end

  describe '.teacher_notification' do
    it "mentions the workshop name in the body" do
      workshop = create(:workshop, name: "Foo bar")

      expect(teacher_notification(workshop: workshop).body).to include "Foo bar"
    end

    it "is from learn@thoughtbot.com" do
      expect(teacher_notification.from).to eq(%w(learn@thoughtbot.com))
    end

    it "mentions the workshop name in the subject" do
      workshop = create(:workshop, name: "Foo bar")

      expect(teacher_notification(workshop: workshop).subject).to include "Foo bar"
    end

    it "is sent to the teacher" do
      teacher = create(:teacher)
      expect(teacher_notification(teacher: teacher).to).to eq([teacher.email])
    end

    def teacher_notification(options = {})
      options[:teacher] ||= create(:teacher)
      options[:workshop] ||= create(:workshop)

      Mailer.teacher_notification(options[:teacher], create(:section, workshop: options[:workshop]))
    end
  end
end
