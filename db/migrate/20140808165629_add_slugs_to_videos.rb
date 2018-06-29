class AddSlugsToVideos < ActiveRecord::Migration[4.2]
  def change
    add_column :videos, :slug, :string, null: true

    videos = select_all("select id, title from videos")
    videos.each do |video|
      update(<<-SQL)
        UPDATE videos
          SET slug='#{video["title"].parameterize}'
          WHERE id=#{video["id"]}
      SQL
    end

    change_column_null :videos, :slug, false
    add_index :videos, :slug, unique: true
  end
end
