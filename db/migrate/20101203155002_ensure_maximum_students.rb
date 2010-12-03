class EnsureMaximumStudents < ActiveRecord::Migration
  def self.up
    change_column :courses, :maximum_students, :integer, :default => 12, :null => false
  end

  def self.down
    change_column :courses, :maximum_students, :integer, :default => nil, :null => true
  end
end
