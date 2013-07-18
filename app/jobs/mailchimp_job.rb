class MailchimpJob < Struct.new(:list_name, :email)
  include ErrorReporting

  PRIORITY = 1
  # http://apidocs.mailchimp.com/api/1.3/exceptions.field.php
  MAILCHIMP_EMAIL_ERROR_CODES = [230, 231, 232, 233, 214]

  def self.enqueue(list_name, email)
    Delayed::Job.enqueue(new(list_name, email))
  end

  private

  def client
    @client ||= Gibbon.new
  end

  def rescue_email_errors
    yield
  rescue Gibbon::MailChimpError => e
    raise e unless MAILCHIMP_EMAIL_ERROR_CODES.include?(e.code)
  end
end
