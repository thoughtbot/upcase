require 'spec_helper'

describe Mailer do
  context '.purchase_receipt' do
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
  end

  context '.registration_confirmation' do
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
  end

  context '.section_reminder' do
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
end
