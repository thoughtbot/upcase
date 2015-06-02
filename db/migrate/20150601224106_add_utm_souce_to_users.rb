class AddUtmSouceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :utm_source, :string
  end
end
