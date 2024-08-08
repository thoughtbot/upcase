class AddUnsubscribedFromEmailsToUser < ActiveRecord::Migration[4.2]
  def change
    add_column(
      :users,
      :unsubscribed_from_emails,
      :boolean,
      null: false,
      default: false
    )
  end
end
