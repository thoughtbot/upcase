class AddBiosToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :bio, :text
  end
end
