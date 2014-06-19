module DashboardsHelper
  def learn_live_link(&block)
    if current_user_has_access_to?(:office_hours)
      link_to OfficeHours.url, target: "_blank", &block
    else
      content_tag "a", &block
    end
  end

  def learn_repo_link(&block)
    if current_user_has_access_to?(:source_code)
      link_to ENV['LEARN_REPO_URL'], target: "_blank", &block
    else
      content_tag "a", &block
    end
  end
end
