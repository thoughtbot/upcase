class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |table|
      table.column :course_id, :integer
      table.column :name,      :string
      table.column :url,       :string
    end
    add_index :resources, :course_id
  end

  def self.down
    remove_index :resources, :column => :course_id
    drop_table :resources
  end
end
