class AddUnsubscribedFromEmailsToUser < ActiveRecord::Migration
  def change
    add_column(
      :users,
      :unsubscribed_from_emails,
      :boolean,
      null: false,
      default: false,
    )
  end
end
