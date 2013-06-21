class ByteNotifier
  def initialize(emails)
    @emails = emails
  end

  def send_notifications
    bytes = Byte.published_today
    bytes.each do |byte|
      @emails.each do |email|
        send_notification(email, byte)
      end
    end
  end

  private

  def send_notification(email, byte)
    Mailer.byte_notification(email, byte).deliver
  rescue *SMTP_ERRORS => error
    Airbrake.notify(error)
  end
end
