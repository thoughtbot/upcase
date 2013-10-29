class DropShowsAndEpisodes < ActiveRecord::Migration
  def change
    drop_table :shows
    drop_table :episodes
  end
end
