class RemoveCheckouts < ActiveRecord::Migration[5.2]
  def change
    drop_table :checkouts
  end
end
