class AddActiveToBetaOffers < ActiveRecord::Migration
  def change
    add_column :beta_offers, :active, :boolean, default: true, null: false
  end
end
