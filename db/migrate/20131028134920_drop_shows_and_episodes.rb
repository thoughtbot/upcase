class DropShowsAndEpisodes < ActiveRecord::Migration[4.2]
  def change
    drop_table :shows
    drop_table :episodes
  end
end
