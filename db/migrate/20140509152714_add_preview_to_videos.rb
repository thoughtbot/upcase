class AddPreviewToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :preview_wistia_id, :string
  end
end
