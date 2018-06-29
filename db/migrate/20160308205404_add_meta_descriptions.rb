class AddMetaDescriptions < ActiveRecord::Migration[4.2]
  def change
    [:products, :trails, :topics, :videos].each do |table_name|
      add_column table_name, :meta_description, :text, default: "", null: false
    end
  end
end
