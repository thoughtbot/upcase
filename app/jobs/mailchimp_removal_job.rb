class MailchimpRemovalJob < MailchimpJob
  def perform
    lists = client.lists(filters: { list_name: list_name })
    client.list_unsubscribe(id: lists['data'].first['id'], email_address: email)
  rescue Gibbon::MailChimpError => e
    raise e unless MAILCHIMP_EMAIL_ERROR_CODES.include?(e.code)
  end
end
