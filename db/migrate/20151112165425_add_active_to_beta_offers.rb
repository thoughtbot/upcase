class AddActiveToBetaOffers < ActiveRecord::Migration[4.2]
  def change
    add_column :beta_offers, :active, :boolean, default: true, null: false
  end
end
