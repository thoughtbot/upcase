class AddFreshbookFieldsToUsers < ActiveRecord::Migration[4.2]
  def self.up
    change_table :users do |t|
      t.string :phone
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :freshbooks_client_id
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :phone
      t.remove :address1
      t.remove :address2
      t.remove :city
      t.remove :state
      t.remove :zip_code
      t.remove :freshbooks_client_id
    end
  end
end
