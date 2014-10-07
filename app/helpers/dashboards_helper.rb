module DashboardsHelper
  MAX_RESOURCES_TO_SHOW = 3

  def has_more_resources?(topic)
    topic.count > MAX_RESOURCES_TO_SHOW
  end

  def locked_dashboard_resource(resource)
    unless current_user_has_access_to?(resource)
      'locked-resource'
    end
  end

  def locked_features
    features.reject { |feature| current_user_has_access_to?(feature) }
  end

  def locked_features_text
    locked_features.to_sentence.humanize
  end

  def subscribe_or_upgrade_link
    if current_user_has_active_subscription?
      link_to t(".locked_features.upgrade_link"), edit_subscription_path
    else
      link_to t(".locked_features.subscribe_link"), new_subscription_path
    end
  end

  def features
    %i(exercises shows video_tutorials)
  end
end
