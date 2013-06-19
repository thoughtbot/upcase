class AddSkuToWorkshops < ActiveRecord::Migration
  def change
    add_column :workshops, :sku, :string
  end
end
