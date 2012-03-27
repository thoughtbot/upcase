class AddTermsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :terms, :text
  end

  def self.down
    remove_column :products, :terms
  end
end
