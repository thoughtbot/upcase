class NotificationMailer < BaseMailer
  def byte_notification(email, byte)
    @byte = byte

    mail(
      to: email,
      from: 'learn@thoughtbot.com',
      reply_to: 'learn@thoughtbot.com',
      subject: "[Learn] New Byte: #{byte.title}"
    )
  end
end
