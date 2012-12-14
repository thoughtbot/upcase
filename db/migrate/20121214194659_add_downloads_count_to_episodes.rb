class AddDownloadsCountToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :downloads_count, :integer, default: 0, null: false
  end
end
