class AddAvailableFlagToMentors < ActiveRecord::Migration
  def change
    add_column :mentors, :accepting_new_mentees, :boolean, null: false, default: true
  end
end
