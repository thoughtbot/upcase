class RemoveVideosActiveOnDay < ActiveRecord::Migration[4.2]
  def change
    remove_column :videos, :active_on_day
  end
end
