class AddDateUserDecidedToCancelToSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :user_clicked_cancel_button_on, :date
  end
end
