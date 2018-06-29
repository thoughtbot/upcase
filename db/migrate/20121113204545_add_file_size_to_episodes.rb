class AddFileSizeToEpisodes < ActiveRecord::Migration[4.2]
  def change
    add_column :episodes, :file_size, :integer
  end
end
