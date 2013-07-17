require 'spec_helper'

describe MailchimpRemovalJob do
  it_behaves_like 'a Delayed Job that notifies Airbrake about errors'

  it 'removes an email from the list' do
    MailchimpRemovalJob.new('product', 'user@example.com').perform

    expect(FakeMailchimp.lists['product']).not_to include 'user@example.com'
  end

  it 'does not raise mailchimp email errors' do
    FakeMailchimp.email_error_response = {
      error: 'already unsubscribed to list',
      code: 231
    }

    expect do
      MailchimpRemovalJob.new('product', 'user@example.com').perform 
    end.not_to raise_error(Gibbon::MailChimpError)
  end

  it 'does raise other mailchimp errors' do
    FakeMailchimp.email_error_response = {
      error: 'merge field required',
      code: 250
    }

    expect do
      MailchimpRemovalJob.new('product', 'user@example.com').perform 
    end.to raise_error(Gibbon::MailChimpError)
  end
end
