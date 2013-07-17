class MailchimpFulfillmentJob < MailchimpJob
  MASTER_LIST_ID = '66f4d45e54'

  def perform
    lists = client.lists(filters: { list_name: list_name })
    subscribe(lists['data'].first['id'], email)
    subscribe(MASTER_LIST_ID, email)
  end

  private

  def subscribe(list_id, email)
    client.list_subscribe(id: list_id, email_address: email, double_optin: false)
  rescue Gibbon::MailChimpError => e
    raise e unless MAILCHIMP_EMAIL_ERROR_CODES.include?(e.code)
  end
end
