class NotificationMailer < BaseMailer
  def byte_notification(email, byte)
    @byte = byte

    mail(
      to: email,
      subject: "[Learn] New Byte: #{byte.title}"
    )
  end
end
