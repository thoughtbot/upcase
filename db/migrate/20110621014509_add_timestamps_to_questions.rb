class AddTimestampsToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :created_at, :datetime
    add_column :questions, :updated_at, :datetime
    update "update questions set created_at = now()"
    update "update questions set updated_at = now()"
  end

  def self.down
    remove_column :questions, :updated_at
    remove_column :questions, :created_at
  end
end
