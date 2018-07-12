class AddDownloadsCountToEpisodes < ActiveRecord::Migration[4.2]
  def change
    add_column :episodes, :downloads_count, :integer, default: 0, null: false
  end
end
