class AddAttachmentToEpisodes < ActiveRecord::Migration[4.2]
  def change
    add_attachment :episodes, :mp3
    remove_column :episodes, :file
  end
end
