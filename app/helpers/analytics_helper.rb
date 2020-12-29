module AnalyticsHelper
  def can_use_analytics?
    ENV["ANALYTICS"].present? && !masquerading?
  end
end
