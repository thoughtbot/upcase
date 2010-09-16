class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |table|
      table.column :course_id, :integer
      table.column :question,  :string
      table.column :answer,    :string
    end
    add_index :questions, :course_id
  end

  def self.down
    remove_index :questions, :column => :course_id
    drop_table :questions
  end
end
