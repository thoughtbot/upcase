class AddDateUserDecidedToCancelToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :user_clicked_cancel_button_on, :date
  end
end
