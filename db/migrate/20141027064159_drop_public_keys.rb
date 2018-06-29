class DropPublicKeys < ActiveRecord::Migration[4.2]
  def change
    drop_table :public_keys do |table|
      table.integer :user_id, null: false
      table.text :data, null: false
      table.timestamps null: false
      table.index :user_id
    end
  end
end
