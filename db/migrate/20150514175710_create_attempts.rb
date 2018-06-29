class CreateAttempts < ActiveRecord::Migration[4.2]
  def change
    create_table :attempts do |t|
      t.integer :confidence, null: false
      t.references :question, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :attempts, :questions, on_delete: :cascade
    add_foreign_key :attempts, :users, on_delete: :cascade
  end
end
