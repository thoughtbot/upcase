require 'spec_helper'

describe MailchimpRemovalJob do
  it_behaves_like 'a Delayed Job that notifies Airbrake about errors'

  it 'removes an email from the list' do
    MailchimpRemovalJob.new('product', 'user@example.com').perform

    expect(FakeMailchimp.lists['product']).not_to include 'user@example.com'
  end
end
