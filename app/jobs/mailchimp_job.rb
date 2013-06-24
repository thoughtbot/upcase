class MailchimpJob < Struct.new(:list_name, :email)
  include ErrorReporting

  PRIORITY = 1

  def self.enqueue(list_name, email)
    Delayed::Job.enqueue(new(list_name, email))
  end

  private

  def client
    @client ||= Gibbon.new
  end
end
