class AddFileSizeToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :file_size, :integer
  end
end
