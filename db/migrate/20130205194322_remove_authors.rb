class RemoveAuthors < ActiveRecord::Migration[4.2]
  def up
    remove_column :articles, :author_id
    drop_table :authors
  end

  def down
    create_table :authors do |t|
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
      t.string :tumblr_user_name, :null => false
      t.string :first_name
      t.string :last_name
      t.string :email
    end

    add_column :articles, :author_id, :integer
  end
end
