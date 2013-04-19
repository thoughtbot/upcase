class AddNotesToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :notes, :text
  end

  def self.down
    remove_column :videos, :notes
  end
end
