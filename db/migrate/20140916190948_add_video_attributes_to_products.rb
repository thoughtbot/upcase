class AddVideoAttributesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :length_in_days, :integer
    add_column :products, :resources, :text, default: "", null: false
  end
end
