class AddSummaryToVideos < ActiveRecord::Migration[4.2]
  def change
    add_column :videos, :summary, :text
  end
end
