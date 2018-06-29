class CreatePublicKeys < ActiveRecord::Migration[4.2]
  def change
    create_table :public_keys do |table|
      table.integer :user_id, null: false
      table.text :data, null: false
      table.timestamps null: false
    end

    add_index :public_keys, :user_id
  end
end
