class AddActiveOnDayToVideos < ActiveRecord::Migration[4.2]
  def change
    add_column :videos, :active_on_day, :integer, null: false, default: 0
  end
end
