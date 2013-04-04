class SectionNotifier
  def initialize(section, emails)
    @section = section
    @emails = emails
  end

  def send_notifications_for(items)
    items.each do |item|
      if item.starts_today?(@section.starts_on)
        @emails.each do |email|
          send_notification(email, item)
        end
      end
    end
  end

  private

  def send_notification(email, item)
    Mailer.section_notification(email, item).deliver
  end
end
