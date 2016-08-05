class Webhooks::IntercomUnsubscribesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    if signature_valid?
      unsubscribe_identified_user
      render nothing: true
    else
      report_invalid_signature
      render nothing: true, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    report_user_not_found_error
    render nothing: true, status: :unprocessable_entity
  end

  private

  def signature_valid?
    provided_signature == calculated_signature
  end

  def unsubscribe_identified_user
    user_from_webhook_data.update(unsubscribed_from_emails: true)
  end

  def user_from_webhook_data
    User.find(JSON.parse(request_body)["data"]["item"]["user_id"])
  end

  def calculated_signature
    OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new("sha1"),
      intercom_secret,
      request_body,
    )
  end

  def provided_signature
    signature_header.split("=").last
  end

  def signature_header
    request.headers["X-Hub-Signature"]
  end

  def intercom_secret
    ENV.fetch("INTERCOM_WEBHOOK_SECRET")
  end

  def request_body
    request.body.read
  end

  def report_invalid_signature
    Honeybadger.notify(
      error_message: "Invalid signature provided with webhook.",
      error_class: "IntercomWebhook",
      context: {
        body: request_body,
        signature: signature_header,
      },
    )
  end

  def report_user_not_found_error
    Honeybadger.notify(
      error_message: "Unable to find user to unsubscribe.",
      error_class: "IntercomWebhook",
      context: { body: request_body },
    )
  end
end
