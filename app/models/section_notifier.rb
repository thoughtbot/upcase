class SectionNotifier
  def initialize(section, purchases)
    @section = section
    @purchases = purchases
  end

  def send_notifications_for(items)
    items.each do |item|
      @purchases.each do |purchase|
        if item.starts_today?(purchase.starts_on)
          send_notification(purchase.email, item)
        end
      end
    end
  end

  private

  def send_notification(email, item)
    Mailer.section_notification(email, item).deliver
  end
end
