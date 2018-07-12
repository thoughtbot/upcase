class CreateEpisodes < ActiveRecord::Migration[4.2]
  def change
    create_table :episodes do |t|
      t.string :title
      t.string :old_url
      t.string :size
      t.string :length
      t.string :file
      t.text :description
      t.text :notes
      t.date :published_on
      t.timestamps
    end
  end
end
