class AddVideoChatUrlToWorkshops < ActiveRecord::Migration[4.2]
  def change
    add_column :workshops, :video_chat_url, :string
  end
end
