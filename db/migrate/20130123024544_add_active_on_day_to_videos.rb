class AddActiveOnDayToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :active_on_day, :integer, null: false, default: 0
  end
end
