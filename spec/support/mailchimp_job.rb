shared_examples 'a MailchimpJob' do
  it 'does not raise mailchimp email errors' do
    FakeMailchimp.email_error_response = {
      error: 'already subscribed to list',
      code: MailchimpJob::MAILCHIMP_EMAIL_ERROR_CODES.first
    }

    expect do
      described_class.new('product', 'user@example.com').perform 
    end.not_to raise_error(Gibbon::MailChimpError)
  end

  it 'does raise other mailchimp errors' do
    FakeMailchimp.email_error_response = {
      error: 'merge field required',
      code: 250
    }

    expect do
      described_class.new('product', 'user@example.com').perform 
    end.to raise_error(Gibbon::MailChimpError)
  end
end
