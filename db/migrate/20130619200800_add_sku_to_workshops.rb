class AddSkuToWorkshops < ActiveRecord::Migration[4.2]
  def change
    add_column :workshops, :sku, :string
  end
end
