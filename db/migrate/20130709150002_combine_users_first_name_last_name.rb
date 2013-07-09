class CombineUsersFirstNameLastName < ActiveRecord::Migration
  def up
    add_column :users, :name, :string
    update "update users set name = first_name || ' ' || last_name"
    remove_column :users, :first_name
    remove_column :users, :last_name
  end

  def down
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
    update "update users set first_name = split_part(name, ' ', 1), last_name = split_part(name, ' ', 2)"
    remove_column :users, :name
  end
end
