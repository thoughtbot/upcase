module AnalyticsHelper
  def can_use_analytics?
    ENV["ANALYTICS"].present? && !masquerading?
  end

  def identify_hash(user = current_user)
    {
      created: user.created_at,
      email: user.email,
      first_name: user.first_name,
      name: user.name,
      unsubscribed_from_emails: user.unsubscribed_from_emails,
      user_id: user.id,
      username: user.github_username,
    }
  end

  def intercom_hash(user = current_user)
    {
      'Intercom' => {
        userHash: OpenSSL::HMAC.hexdigest(
          'sha256',
          ENV['INTERCOM_API_SECRET'],
          user.id.to_s
        )
      }
    }
  end

  def campaign_hash
    {
      context: {
        campaign: session[:campaign_params]
      }
    }
  end
end
