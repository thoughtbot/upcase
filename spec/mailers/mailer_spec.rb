require 'spec_helper'

describe Mailer do
  describe '.follow_up' do
    include Rails.application.routes.url_helpers

    it "mentions the workshop name" do
      workshop = create(:workshop, name: "Foo bar")
      follow_up_for(workshop: workshop).body.should include "Foo bar"
    end

    it "is from learn@thoughtbot.com" do
      follow_up_for.from.should eq(%w(learn@thoughtbot.com))
    end

    it "mentions the workshop name in the subject" do
      workshop = create(:workshop, name: "Foo bar")
      follow_up_for(workshop: workshop).subject.should include "Foo bar"
    end

    it "is sent to the follow up email" do
      follow_up = create(:follow_up)

      follow_up_for(follow_up: follow_up).to.should eq([follow_up.email])
    end

    it "links to the workshop" do
      workshop = create(:workshop)

      follow_up_for(workshop: workshop).body.should include workshop_url(workshop)
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
      mailer.should deliver_to(purchase.email)
      mailer.should cc_to('learn@thoughtbot.com')
      mailer.should reply_to('learn@thoughtbot.com')
    end

    it 'sets the correct subject' do
      purchase = stubbed_purchase
      mailer = Mailer.fulfillment_error(purchase, github_username)
      mailer.should have_subject(
        "Fulfillment issues with #{purchase.purchaseable_name}")
    end

    it 'sets the username in the message body' do
      mailer = Mailer.fulfillment_error(stubbed_purchase, github_username)
      mailer.should have_body_text(/#{github_username}/)
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
        email = Mailer.purchase_receipt(purchase)
        expect(email).not_to have_body_text(/download/)
      end
    end

    context 'for a non-workshop purchase' do
      it 'does contain text about downloading' do
        purchase = create(:book_purchase)
        email = Mailer.purchase_receipt(purchase)
        expect(email).to have_body_text(/download/)
      end
    end

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
        @email.should have_subject(/Your receipt for #{purchase.purchaseable_name}/)
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
        announcement = create(:announcement, announceable: purchase.purchaseable)
        email = Mailer.purchase_receipt(purchase)
        expect(email).to have_body_text(/#{announcement.message}/)
      end
    end
  end

  describe '.registration_confirmation' do
    include Rails.application.routes.url_helpers

    context 'for a registration without a user' do
      let(:purchase) do
        create :section_purchase, :email => 'joe@example.com'
      end

      before do
        @email = Mailer.registration_confirmation(purchase)
      end

      it 'contains a link to create a new account in the body' do
        @email.should have_body_text(/#{new_user_url(host: HOST)}/)
      end
    end

    context 'for a registration with a user' do
      let(:purchase) do
        create :section_purchase, user: create(:user)
      end

      before do
        @email = Mailer.registration_confirmation(purchase)
      end

      it 'does not contain a link to create a new account in the body' do
        @email.should_not have_body_text(/#{new_user_url(host: HOST)}/)
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
  end

  describe '.registration_notification' do
    around do |example|
      Timecop.freeze Date.parse('2012-09-12') do
        example.run
      end
    end

    it 'includes starts_on and ends_on in the email body' do
      purchase = build_purchase
      email = Mailer.registration_notification(purchase)
      email.body.should include purchase.purchaseable.date_range
    end

    it 'includes section city in the email body' do
      purchase = build_purchase_in 'San Antonio'
      email = Mailer.registration_notification(purchase)
      email.body.should include 'San Antonio'
    end

    def build_purchase
      build_stubbed(:section_purchase)
    end

    def build_purchase_in(city)
      build_purchase.tap do |purchase|
        purchase.purchaseable.city = city
      end
    end
  end

  describe '.section_reminder' do
    let(:workshop_name) do
      'Hilarious Backbone.js'
    end

    let(:recipient) do
      'frankie-z@example.com'
    end

    let(:sent_email) do
      workshop = create(:workshop, name: workshop_name)
      section = create(:section, workshop: workshop)

      purchase = create(:purchase,
                        purchaseable: section,
                        email: recipient,
                        name: 'Benny Burns')

      Mailer.section_reminder purchase, section
    end

    it 'has the correct subject' do
      sent_email.subject.should =~ /#{workshop_name}/
    end

    it 'has the correct recipient' do
      sent_email.to.should include(recipient)
    end

    it "has the registrant's name in the body" do
      sent_email.body.should include('Benny Burns')
    end
  end

  describe '.teacher_notification' do
    subject do
      Mailer.teacher_notification teacher, create(:section, workshop: workshop)
    end

    let(:workshop) do
      create :workshop
    end

    let(:teacher) do
      create :teacher
    end

    its(:body) { should match(/#{workshop.name}/) }
    its(:from) { should eq(%w(learn@thoughtbot.com)) }
    its(:subject) { should match(/#{workshop.name}/) }
    its(:to) { should eq([teacher.email]) }
  end
end
