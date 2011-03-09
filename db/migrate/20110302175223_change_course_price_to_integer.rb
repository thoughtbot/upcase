class ChangeCoursePriceToInteger < ActiveRecord::Migration
  def self.up
    change_column :courses, :price, :integer, :null => true, :default => nil
  end

  def self.down
    change_column :courses, :price, :string, :null => false, :default => ""
  end
end
