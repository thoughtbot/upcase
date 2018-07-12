class AddAvailableFlagToMentors < ActiveRecord::Migration[4.2]
  def change
    add_column :mentors, :accepting_new_mentees, :boolean, null: false, default: true
  end
end
