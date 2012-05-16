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
end
