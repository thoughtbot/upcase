class MailchimpJob < Struct.new(:list_name, :email)
  include ErrorReporting

  PRIORITY = 1
  MAILCHIMP_EMAIL_ERROR_CODES = [230, 231, 232, 233]

  def self.enqueue(list_name, email)
    Delayed::Job.enqueue(new(list_name, email))
  end

  private

  def client
    @client ||= Gibbon.new
  end
end
