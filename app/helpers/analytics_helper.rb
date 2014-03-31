module AnalyticsHelper
  def analytics?
    ENV['ANALYTICS']
  end

  def analytics_hash(user = current_user)
    {
      created: user.created_at,
      email: user.email,
      has_active_subscription: user.has_active_subscription?,
      has_logged_in_to_forum: user.has_logged_in_to_forum?,
      mentor_name: user.mentor_name,
      name: user.name,
      plan: user.plan_name,
      subscribed_at: user.subscribed_at,
      username: user.github_username,
      stripe_customer_url: StripeCustomer.new(user).url,
    }
  end

  def intercom_hash(user = current_user)
    {
      'Intercom' => {
        userHash: OpenSSL::HMAC.hexdigest(
          'sha256',
          ENV['INTERCOM_API_SECRET'],
          user.id.to_s)
      }
    }
  end

  def purchased_hash(purchase_amount, purchase_name)
    {
      revenue: purchase_amount,
      label: purchase_name
    }
  end
end
