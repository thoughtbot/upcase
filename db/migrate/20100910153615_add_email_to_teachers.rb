class AddEmailToTeachers < ActiveRecord::Migration
  def self.up
    add_column :teachers, :email, :string, :default => ''
  end

  def self.down
    remove_column :teachers, :email
  end
end
