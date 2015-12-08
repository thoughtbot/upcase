def find_user(email)
  User.find_by_email(email)
end

def create_video_markers(slug:, markers:)
  Video.find_by(slug: slug).tap do |video|
    markers.each do |anchor, time|
      video.markers.find_or_create_by(anchor: anchor, time: time)
    end
  end
end

