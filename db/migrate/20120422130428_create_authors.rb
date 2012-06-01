class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.timestamps null: false
      t.string :tumblr_user_name, null: false
      t.string :first_name
      t.string :last_name
      t.string :email
    end

    add_index :authors, :tumblr_user_name, unique: true
  end
end
