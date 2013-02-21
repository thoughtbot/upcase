class Notifier
  def initialize(section, emails)
    @section = section
    @emails = emails
  end

  def send_notifications_for(items)
    items.each do |item|
      if item.starts_today?(@section.start_date)
        @emails.each do |email|
          send_notification(email, item)
        end
      end
    end
  end

  private

  def send_notification(email, item)
    Mailer.notification(email, item)
  end
end
