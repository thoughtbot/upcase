class IntroducePurchaseable < ActiveRecord::Migration
  def up
    add_column :purchases, :purchaseable_id, :integer
    add_column :purchases, :purchaseable_type, :string
    update "update purchases set purchaseable_type='Product', purchaseable_id=product_id"
    remove_column :purchases, :product_id
  end

  def down
    update "update purchases set product_id=purchaseable_id where purchaseable_type='Product'"
    remove_column :purchases, :purchaseable_type
    remove_column :purchases, :purchaseable_id
  end
end
