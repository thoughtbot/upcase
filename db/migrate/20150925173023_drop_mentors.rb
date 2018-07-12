class DropMentors < ActiveRecord::Migration[4.2]
  def change
    drop_table :mentors
    remove_column :plans, :includes_mentor
    remove_column :users, :mentor_id
  end
end
