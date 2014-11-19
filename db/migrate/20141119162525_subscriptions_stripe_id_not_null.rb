class SubscriptionsStripeIdNotNull < ActiveRecord::Migration
  HARVEST_SUSCRIPTION_IDS = [1463, 1400]

  def change
    destroy_deactivated_subscriptions_with_no_stripe_id
    add_special_stripe_id_to_harvest_subscriptions
    change_column_null :subscriptions, :stripe_id, false
  end

  private

  def destroy_deactivated_subscriptions_with_no_stripe_id
    Subscription.
      where(stripe_id: nil).
      where("deactivated_on IS NOT NULL").
      destroy_all
  end

  def add_special_stripe_id_to_harvest_subscriptions
    Subscription.
      where(id: HARVEST_SUSCRIPTION_IDS).
      update_all(stripe_id: "sub_HARVEST")
  end
end
