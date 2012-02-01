class MoveUsersToRegistration < ActiveRecord::Migration
  def self.up
    add_column :registrations, :email, :string
    add_column :registrations, :billing_email, :string
    add_column :registrations, :first_name, :string
    add_column :registrations, :last_name, :string
    add_column :registrations, :organization, :string
    add_column :registrations, :phone, :string
    add_column :registrations, :address1, :string
    add_column :registrations, :address2, :string
    add_column :registrations, :city, :string
    add_column :registrations, :state, :string
    add_column :registrations, :zip_code, :string
    add_column :registrations, :freshbooks_client_id, :string

    update("update registrations set email=users.email, billing_email=users.email, first_name=users.first_name, last_name=users.last_name, organization=users.organization, phone=users.phone, address1=users.address1, address2=users.address2, city=users.city, state=users.state, zip_code=users.zip_code, freshbooks_client_id=users.freshbooks_client_id FROM users WHERE user_id=users.id")

    remove_column :registrations, :user_id
    remove_column :users, :organization
    remove_column :users, :phone
    remove_column :users, :address1
    remove_column :users, :address2
    remove_column :users, :city
    remove_column :users, :state
    remove_column :users, :zip_code
    remove_column :users, :freshbooks_client_id
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
