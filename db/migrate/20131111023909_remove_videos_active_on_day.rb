class RemoveVideosActiveOnDay < ActiveRecord::Migration
  def change
    remove_column :videos, :active_on_day
  end
end
