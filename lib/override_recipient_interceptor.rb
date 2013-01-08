class OverrideRecipientInterceptor
  def self.delivering_email(message)
    add_custom_headers(message)
    message.to = ENV['EMAIL_RECIPIENTS'].split(',')
    message.cc = nil
    message.bcc = nil
  end

  private

  def self.add_custom_headers(message)
    {
      'X-Override-To' => message.to,
      'X-Override-Cc' => message.cc,
      'X-Override-Bcc' => message.bcc
    }.each do |header, addresses|
      if addresses
        addresses.each do |address|
          message.header = "#{message.header}\n#{header}: #{address}"
        end
      end
    end
  end
end

if Rails.env.staging?
  Mail.register_interceptor(OverrideRecipientInterceptor)
end
