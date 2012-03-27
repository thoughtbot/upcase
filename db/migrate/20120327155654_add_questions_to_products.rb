class AddQuestionsToProducts < ActiveRecord::Migration
  def self.up
    rename_column :products, :terms, :questions
    add_column :products, :terms, :text
  end

  def self.down
    remove_column :products, :terms
    rename_column :products, :questions, :terms
  end
end
