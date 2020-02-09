class DropBetaTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :beta_replies
    drop_table :beta_offers
  end
end
