class NullLicense
  def owned_by?(_)
    false
  end

  def active?
    false
  end

  def eligible_for_annual_upgrade?
    false
  end

  def grants_access_to?(_)
    false
  end
end
