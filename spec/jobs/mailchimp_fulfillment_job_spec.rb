require 'spec_helper'

describe MailchimpFulfillmentJob do
  it_behaves_like 'a Delayed Job that notifies Airbrake about errors'

  it 'adds an email to the given list and the master list' do
    FakeMailchimp.master_list = MailchimpFulfillmentJob::MASTER_LIST_ID

    MailchimpFulfillmentJob.new('product', 'user@example.com').perform

    master_list = FakeMailchimp.lists[MailchimpFulfillmentJob::MASTER_LIST_ID]
    expect(master_list).to include 'user@example.com'
    expect(FakeMailchimp.lists['product']).to include 'user@example.com'
  end

  it 'does not raise mailchimp email errors' do
    FakeMailchimp.email_error_response = {
      error: 'already subscribed to list',
      code: 230
    }

    expect do
      MailchimpFulfillmentJob.new('product', 'user@example.com').perform 
    end.not_to raise_error(Gibbon::MailChimpError)

    FakeMailchimp.email_error_response = nil
  end

  it 'does raise other mailchimp errors' do
    FakeMailchimp.email_error_response = {
      error: 'merge field required',
      code: 250
    }

    expect do
      MailchimpFulfillmentJob.new('product', 'user@example.com').perform 
    end.to raise_error(Gibbon::MailChimpError)

    FakeMailchimp.email_error_response = nil
  end
end
