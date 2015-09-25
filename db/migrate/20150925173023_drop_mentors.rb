class DropMentors < ActiveRecord::Migration
  def change
    drop_table :mentors
    remove_column :plans, :includes_mentor
    remove_column :users, :mentor_id
  end
end
