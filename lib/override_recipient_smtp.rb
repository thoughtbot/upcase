require Rails.root.join('config/initializers/mail')

class OverrideRecipientSMTP < Mail::SMTP
  def initialize(_)
    self.settings = MAIL_SETTINGS
  end

  def deliver!(mail)
    store_in_custom_headers(mail)

    mail.to = ENV['EMAIL_RECIPIENTS'].split(',')
    mail.cc = nil
    mail.bcc = nil

    super(mail)
  end

  private

  def store_in_custom_headers(mail)
    {
      'X-Override-To' => mail.to,
      'X-Override-Cc' => mail.cc,
      'X-Override-Bcc' => mail.bcc
    }.each do |header, addresses|
      if addresses
        addresses.each do |address|
          mail.header = "#{mail.header}\n#{header}: #{address}"
        end
      end
    end
  end
end

ActionMailer::Base.add_delivery_method :override_recipient_smtp,
  OverrideRecipientSMTP
