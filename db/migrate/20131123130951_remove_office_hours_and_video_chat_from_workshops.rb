class RemoveOfficeHoursAndVideoChatFromWorkshops < ActiveRecord::Migration
  def change
    remove_column :workshops, :office_hours
    remove_column :workshops, :video_chat_url
  end
end
