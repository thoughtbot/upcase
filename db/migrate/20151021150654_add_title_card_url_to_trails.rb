class AddTitleCardUrlToTrails < ActiveRecord::Migration
  def change
    add_column :trails, :title_card_image, :string, default: ""
  end
end
