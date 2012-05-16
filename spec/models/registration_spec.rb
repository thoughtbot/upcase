require 'spec_helper'

describe Registration do
  it { should belong_to(:section) }
  it { should belong_to(:coupon) }

  it { should validate_presence_of(:organization) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:billing_email) }
end
