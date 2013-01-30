class AddVideoChatUrlToWorkshops < ActiveRecord::Migration
  def change
    add_column :workshops, :video_chat_url, :string
  end
end
