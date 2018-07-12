class CreateShows < ActiveRecord::Migration[4.2]
  def change
    create_table :shows do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.string :short_description, null: false
      t.text :description, null: false
      t.text :credits, null: false
      t.string :keywords, null: false
      t.string :itunes_url, null: false
      t.string :stitcher_url
      t.string :email, null: false

      t.timestamps
    end

    add_column :episodes, :show_id, :integer
    add_index :episodes, :show_id

    update "UPDATE episodes set old_url = 'http://upcase.com/podcast/' || id WHERE old_url IS NULL"
  end
end
