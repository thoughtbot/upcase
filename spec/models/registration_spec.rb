require 'spec_helper'

describe Registration do
  # Associations
  it { should belong_to(:coupon) }
  it { should have_one(:course).through(:section) }
  it { should belong_to(:section) }
  it { should belong_to(:user) }

  # Validations
  it { should validate_presence_of(:billing_email) }
  it { should validate_presence_of(:email) }
  it { should allow_value('chad-help@co.uk').for(:email) }
  it { should allow_value('chad-help@thoughtbot.com').for(:email) }
  it { should allow_value('chad.help@thoughtbot.com').for(:email) }
  it { should allow_value('chad@thoughtbot.com').for(:email) }
  it { should_not allow_value('chad').for(:email) }
  it { should_not allow_value('chad@blah').for(:email) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:organization) }

  describe "self.paid" do
    it "returns paid registrations" do
      paid = create(:registration, paid: true)
      unpaid = create(:registration, paid: false)
      Registration.paid.should == [paid]
    end
  end

  describe '.by_email' do
    it 'returns matching registrations' do
      email = 'user@example.com'

      prev_registrations = [
        create(:registration, email: email),
        create(:registration, email: email)
      ]

      other_registration = create(:registration)
      Registration.by_email(email).should =~ prev_registrations
      Registration.by_email(email).should_not include(other_registration)
    end
  end

  describe '#defaults_from_user' do
    it 'populates default info when given a purchaser' do
      purchaser = create(:user)
      registration = Registration.new
      registration.defaults_from_user(purchaser)
      registration.email.should == purchaser.email
      registration.first_name.should == purchaser.first_name
      registration.last_name.should == purchaser.last_name
    end
  end

  describe '#freshbooks_invoice_url' do
    it 'uses the freshbooks_invoice_url if available' do
      registration = build_stubbed(
        :registration, freshbooks_invoice_url: 'http://example.com')
      registration.freshbooks_invoice_url.should == 'http://example.com'
    end

    it 'uses fetch_invoice_url if freshbooks_invoice_url is not available' do
      Mocha::Configuration.allow(:stubbing_non_public_method) do
        registration = build_stubbed(:registration, freshbooks_invoice_url: nil)
        registration.expects :fetch_invoice_url
        registration.freshbooks_invoice_url
      end
    end
  end

  describe '#name' do
    it 'forms a name from first and last name' do
      registration = build(
        :registration, first_name: 'Bruce', last_name: 'Banner')
      registration.name.should == 'Bruce Banner'
    end
  end

  describe '#price' do
    it 'returns the section price when no coupon is applied' do
      registration = build_stubbed(:registration)
      registration.expects :section_price
      registration.price
    end

    it 'delegates to coupon for price when a coupon is applied' do
      coupon = build_stubbed(:coupon)
      registration = build_stubbed(:registration, coupon: coupon)
      coupon.expects(:apply).with registration.section_price
      registration.price
    end
  end

  describe '#receive_payment!' do
    it 'can receive a payment' do
      Mocha::Configuration.allow(:stubbing_non_public_method) do
        registration = build_stubbed(:registration, paid: false)
        registration.expects :send_payment_confirmations
        registration.receive_payment!
        registration.should be_paid
        registration.should_not be_changed
      end
    end

    it 'uses a one-time coupon' do
      coupon = create(:one_time_coupon, amount: 25)
      registration = create(:registration, coupon: coupon)
      coupon.expects :applied
      registration.receive_payment!
    end
  end

  describe '#section_price' do
    it 'delegates to section for course price' do
      registration = build_stubbed(:registration)
      registration.section.expects :course_price
      registration.section_price
    end
  end
end
