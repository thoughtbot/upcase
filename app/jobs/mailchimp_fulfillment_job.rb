class MailchimpFulfillmentJob < MailchimpJob
  MASTER_LIST_ID = '66f4d45e54'

  def perform
    lists = client.lists(filters: { list_name: list_name })

    if lists['total'] > 0
      subscribe(lists['data'].first['id'])
    else
      notify_about_missing_list
    end

    subscribe(MASTER_LIST_ID)
  end

  private

  def subscribe(list_id)
    rescue_email_errors do
      client.list_subscribe(id: list_id, email_address: email, double_optin: false)
    end
  end

  def notify_about_missing_list
    Airbrake.notify_or_ignore({
      error_message: "Missing Mailchimp mailing list: #{list_name}",
      error_class: 'MailchimpError',
      parameters: {
        list_name: list_name,
        subscriber_email: email
      }
    })
  end
end
