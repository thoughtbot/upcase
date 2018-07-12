class AddOneTimeUseOnlyToCoupons < ActiveRecord::Migration[4.2]
  def change
    add_column :coupons, :one_time_use_only, :boolean, default: false, null: false
  end
end
