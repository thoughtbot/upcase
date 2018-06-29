class AddPreviewToVideos < ActiveRecord::Migration[4.2]
  def change
    add_column :videos, :preview_wistia_id, :string
  end
end
