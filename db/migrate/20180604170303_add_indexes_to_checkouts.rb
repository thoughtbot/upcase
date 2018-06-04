class AddIndexesToCheckouts < ActiveRecord::Migration
  def change
    add_index :checkouts, :plan_id
  end
end
