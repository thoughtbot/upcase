module LicensesHelper
  def license_date_range(license)
    formatted_date_range(license.starts_on, license.ends_on)
  end

  def formatted_date_range(starts_on, ends_on)
    if starts_on.nil? || ends_on.nil?
      nil
    elsif starts_on == ends_on
      starts_on.to_s :simple
    elsif starts_on.year != ends_on.year
      "#{starts_on.to_s(:simple)}-#{ends_on.to_s(:simple)}"
    elsif starts_on.month != ends_on.month
      "#{starts_on.strftime('%B %d')}-#{ends_on.to_s(:simple)}"
    else
      "#{starts_on.strftime('%B %d')}-#{ends_on.strftime('%d, %Y')}"
    end
  end
end
