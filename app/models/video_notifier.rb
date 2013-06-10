class VideoNotifier
  def initialize(section, purchases)
    @section = section
    @purchases = purchases
  end

  def send_notifications_for(videos)
    videos.each do |video|
      @purchases.each do |purchase|
        if video.starts_today?(purchase.starts_on)
          send_notification(purchase.email, video)
        end
      end
    end
  end

  private

  def send_notification(email, item)
    Mailer.video_notification(email, item).deliver
  end
end
