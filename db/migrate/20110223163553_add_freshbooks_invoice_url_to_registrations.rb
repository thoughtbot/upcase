class AddFreshbooksInvoiceUrlToRegistrations < ActiveRecord::Migration[4.2]
  def self.up
    change_table :registrations do |t|
      t.string :freshbooks_invoice_url
    end
  end

  def self.down
    change_table :registrations do |t|
      t.remove :freshbooks_invoice_url
    end
  end
end
