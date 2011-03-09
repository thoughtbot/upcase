class CreateFreshbooksInvoiceIdOnRegistration < ActiveRecord::Migration
  def self.up
    add_column :registrations, :freshbooks_invoice_id, :integer
  end

  def self.down
    remove_column :registrations, :freshbooks_invoice_id
  end
end
