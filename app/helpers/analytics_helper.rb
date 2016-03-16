module AnalyticsHelper
  def analytics?
    ENV["ANALYTICS"].present?
  end

  def identify_hash(user = current_user)
    {
      created: user.created_at,
      email: user.email,
      first_name: user.first_name,
      has_active_subscription: user.subscriber?,
      name: user.name,
      plan: user.plan_name,
      scheduled_for_deactivation_on: user.scheduled_for_deactivation_on,
      stripe_customer_url: StripeCustomer.new(user).url,
      subscribed_at: user.subscribed_at,
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

  def purchased_hash
    campaign_hash.merge(revenue: flash[:purchase_amount])
  end

  def campaign_hash
    {
      context: {
        campaign: session[:campaign_params]
      }
    }
  end
end
