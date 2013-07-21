class AddAttachmentToEpisodes < ActiveRecord::Migration
  def change
    add_attachment :episodes, :mp3
    remove_column :episodes, :file
  end
end
