class RemoveLengthInDays < ActiveRecord::Migration[4.2]
  def up
    remove_column :products, :length_in_days
  end

  def down
    add_column :products, :length_in_days, :integer
  end
end
