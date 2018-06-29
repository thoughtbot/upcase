class CreateFreshbooksInvoiceIdOnRegistration < ActiveRecord::Migration[4.2]
  def self.up
    add_column :registrations, :freshbooks_invoice_id, :integer
  end

  def self.down
    remove_column :registrations, :freshbooks_invoice_id
  end
end
