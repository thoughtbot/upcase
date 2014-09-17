module DashboardsHelper
  MAX_RESOURCES_TO_SHOW = 3

  def live_chat_link(&block)
    if current_user_has_access_to?(:office_hours)
      link_to OfficeHours.url, target: "_blank", &block
    else
      content_tag "a", &block
    end
  end

  def upcase_repo_link(&block)
    if current_user_has_access_to?(:source_code)
      link_to ENV['UPCASE_REPO_URL'], target: "_blank", &block
    else
      content_tag "a", &block
    end
  end

  def has_more_resources?(topic)
    topic.count > MAX_RESOURCES_TO_SHOW
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
    %i(exercises screencasts shows video_tutorials)
  end
end
