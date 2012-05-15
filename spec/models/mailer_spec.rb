require 'spec_helper'

describe "Signup Email" do
  let(:purchase) { Factory.build(:purchase, email: "joe@example.com", name: "Joe Smith", created_at: Time.now) }

  before(:all) do
    FetchAPI::Order.stubs(:find).returns(stub(link_full: "http://fetchurl"))
    @email = Mailer.purchase_receipt(purchase)
  end

  it "is to the email passed in" do
    @email.should deliver_to(purchase.email)
  end

  it "contains the name in the mail body" do
    @email.should have_body_text(/#{purchase.name}/)
  end

  it "contains the price of the purchase" do
    @email.should have_body_text(/\$#{purchase.price}\.00/)
  end

  it "should have the correct subject" do
    @email.should have_subject(/Your receipt for #{purchase.product.name}/)
  end
end

describe "Section reminders" do
  let(:course_name) { "Hilarious Backbone.js" }
  let(:recipient) { "frankie-z@example.com" }

  let(:sent_email) do
    course = create(:course, name: course_name)
    section = create(:section, course: course)
    registration = create(:registration,
                          section: section,
                          email: recipient,
                          first_name: "Benny",
                          last_name: "Burns")

    Mailer.section_reminder(registration, section)
  end

  it 'has the correct subject' do
    sent_email.subject.should =~ /#{course_name}/
  end

  it 'has the correct recipient' do
    sent_email.to.should include(recipient)
  end

  it "has the registrant's name in the body" do
    sent_email.body.should include("Benny Burns")
  end
end
