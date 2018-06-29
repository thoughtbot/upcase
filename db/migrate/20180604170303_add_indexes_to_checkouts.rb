class AddIndexesToCheckouts < ActiveRecord::Migration[4.2]
  def change
    add_index :checkouts, :plan_id
  end
end
