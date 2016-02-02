class Guest
  def subscriber?
    false
  end

  def sampler?
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
