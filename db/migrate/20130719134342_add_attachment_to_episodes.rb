class AddAttachmentToEpisodes < ActiveRecord::Migration[4.2]
  def change
    add_column :episodes, :mp3_file_name, :string
    add_column :episodes, :mp3_content_type, :string
    add_column :episodes, :mp3_file_size, :integer
    add_column :episodes, :mp3_updated_at, :datetime
    remove_column :episodes, :file
  end
end
