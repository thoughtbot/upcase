class Guest
  GUEST_TRACKING_ID = "guest".freeze

  def id
    GUEST_TRACKING_ID
  end

  def admin?
    false
  end

  def has_access_to?(_feature)
    false
  end

  def team
    nil
  end

  def email
    nil
  end

  def statuses
    Status.none
  end
end
