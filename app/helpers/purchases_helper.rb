module PurchasesHelper
  def display_card_type(type)
    if type == "American Express"
      "AMEX"
    else
      type
    end
  end

  def submit_amount(checkout)
    "#{subscription_price(checkout)} per #{subscription_interval(checkout)}"
  end

  def subscription_price(checkout)
    number_to_currency(checkout.price, precision: 0)
  end

  def subscription_interval(checkout)
    checkout.subscribeable.subscription_interval
  end

  def purchase_date_range(purchase)
    formatted_date_range(purchase.starts_on, purchase.ends_on)
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

  def choose_plan_link(sku)
    if current_user_has_active_subscription?
      change_plan_link(sku)
    else
      new_plan_link(sku)
    end
  end

  def need_to_collect_github_username?
    signed_in? && current_user.github_username.blank?
  end

  def need_to_create_user_account?
    signed_out?
  end

  private

  def change_plan_link(sku)
    if current_user.plan.sku == sku
      I18n.t('subscriptions.current_plan_html').html_safe
    else
      update_plan_link(sku)
    end
  end

  def update_plan_link(sku)
    link_to(
      I18n.t('subscriptions.choose_plan_html').html_safe,
      subscription_path(plan_id: sku),
      method: :put,
      class: 'sign-up'
    )
  end

  def new_plan_link(sku)
    link_to(
      I18n.t('subscriptions.choose_plan_html').html_safe,
      new_individual_plan_purchase_path(sku),
      class: 'sign-up'
    )
  end
end
