require 'spec_helper'

describe Subscription do
  it { should delegate(:stripe_customer).to(:user) }
end
