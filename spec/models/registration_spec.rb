require 'spec_helper'

describe Registration do
  it { should belong_to(:section) }
  it { should belong_to(:coupon) }

  it { should validate_presence_of(:organization) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:billing_email) }

  it "validates the format of e-mail" do
    should allow_value('chad@thoughtbot.com').for(:email)
    should allow_value('chad.help@thoughtbot.com').for(:email)
    should allow_value('chad-help@thoughtbot.com').for(:email)
    should allow_value('chad-help@co.uk').for(:email)
    should_not allow_value('chad').for(:email)
    should_not allow_value('chad@blah').for(:email)
  end

  it "forms a name from first and last name" do
    registration = build(:registration, first_name: "Bruce", last_name: "Banner")
    registration.name.should == "Bruce Banner"
  end

  it "can receive a payment" do
    registration = build_stubbed(:registration, paid: false)
    registration.expects("send_payment_confirmations")
    registration.receive_payment!
    registration.should be_paid
    registration.should_not be_changed
  end

  it "delegates to section for course price" do
    registration = build_stubbed(:registration)
    registration.section.expects("course_price")
    registration.section_price
  end

  it "delgates to coupon for price when a coupon is applied" do
    coupon = build_stubbed(:coupon)
    registration = build_stubbed(:registration, coupon: coupon)
    coupon.expects("apply").with(registration.section_price)
    registration.price
  end

  it "returns the section price when no coupon is applied" do
    registration = build_stubbed(:registration)
    registration.expects("section_price")
    registration.price
  end

  it "uses the freshbooks_invoice_url is available" do
    registration = build_stubbed(:registration, freshbooks_invoice_url: "https://example.com")
    registration.freshbooks_invoice_url.should == "https://example.com"
  end

  it "uses the fetch_invoiceurl for freshbooks_invoice_url if one is not available" do
    registration = build_stubbed(:registration, freshbooks_invoice_url: nil)
    registration.expects("fetch_invoice_url")
    registration.freshbooks_invoice_url
  end
end
