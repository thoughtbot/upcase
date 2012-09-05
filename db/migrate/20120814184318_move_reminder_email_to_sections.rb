class MoveReminderEmailToSections < ActiveRecord::Migration
  def up
    add_column :sections, :reminder_email, :text
    remove_column :courses, :reminder_email
  end

  def down
    add_column :courses, :reminder_email, :text
    remove_column :sections, :reminder_email
  end
end
