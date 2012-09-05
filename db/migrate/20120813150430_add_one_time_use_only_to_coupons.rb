class AddOneTimeUseOnlyToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :one_time_use_only, :boolean, default: false, null: false
  end
end
