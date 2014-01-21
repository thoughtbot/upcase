module AnalyticsHelper
  def analytics_hash
    {
      created: current_user.created_at,
      email: current_user.email,
      has_active_subscription: current_user.has_active_subscription?,
      has_logged_in_to_forum: current_user.has_logged_in_to_forum?,
      mentor_name: current_user.mentor_name,
      name: current_user.name,
      plan: current_user.plan_name,
      subscribed_at: current_user.subscribed_at,
      username: current_user.github_username
    }
  end

  def intercom_hash
    {
      'Intercom' => {
        userHash: OpenSSL::HMAC.hexdigest('sha256', ENV['INTERCOM_API_SECRET'], current_user.id.to_s)
      }
    }
  end
end
