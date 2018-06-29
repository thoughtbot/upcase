class AddTermsToProducts < ActiveRecord::Migration[4.2]
  def self.up
    add_column :products, :terms, :text
  end

  def self.down
    remove_column :products, :terms
  end
end
