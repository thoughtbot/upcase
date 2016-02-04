class Guest
  def has_active_subscription?
    false
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
