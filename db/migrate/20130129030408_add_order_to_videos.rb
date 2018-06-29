class AddOrderToVideos < ActiveRecord::Migration[4.2]
  def change
    add_column :videos, :order, :integer, default: 0, null: false
  end
end
