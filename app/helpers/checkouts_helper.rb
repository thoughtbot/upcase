module CheckoutsHelper
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

  def choose_plan_link(plan)
    if current_user_has_active_subscription?
      change_plan_link(plan)
    else
      new_plan_link(plan)
    end
  end

  def need_to_collect_github_username?
    signed_in? && current_user.github_username.blank?
  end

  def need_to_create_user_account?
    signed_out?
  end

  def checkout_form_partial(subscribeable)
    if subscribeable.includes_team?
      "checkouts/team_plan_form"
    else
      "checkouts/individual_plan_form"
    end
  end

  private

  def change_plan_link(plan)
    if current_user.plan == plan
      I18n.t("subscriptions.current_plan_html").html_safe
    else
      update_plan_link(plan)
    end
  end

  def update_plan_link(plan)
    link_to(
      I18n.t("subscriptions.choose_plan_html").html_safe,
      subscription_path(plan_id: plan),
      method: :put,
      class: "sign-up"
    )
  end

  def new_plan_link(plan)
    link_to(
      I18n.t("subscriptions.choose_plan_html").html_safe,
      new_checkout_path(plan),
      class: "sign-up"
    )
  end
end
