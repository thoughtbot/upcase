class CreateBetaOffers < ActiveRecord::Migration
  def change
    create_table :beta_offers do |t|
      t.string :name, null: false
      t.text :description, null: false

      t.timestamps null: false
    end
  end
end
