class AddTitleCardUrlToTrails < ActiveRecord::Migration[4.2]
  def change
    add_column :trails, :title_card_image, :string, default: ""
  end
end
