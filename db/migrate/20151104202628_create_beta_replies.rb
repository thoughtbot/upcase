class CreateBetaReplies < ActiveRecord::Migration[4.2]
  def change
    create_table :beta_replies do |t|
      t.belongs_to :offer, index: true, null: false
      t.belongs_to :user, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    add_foreign_key :beta_replies, :beta_offers, column: :offer_id
    add_index :beta_replies, [:offer_id, :user_id], unique: true
  end
end
