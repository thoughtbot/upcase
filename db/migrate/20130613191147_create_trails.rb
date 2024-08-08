class CreateTrails < ActiveRecord::Migration[4.2]
  def up
    create_table :trails do |t|
      t.belongs_to :topic
      t.string :slug
      t.text :trail_map

      t.timestamps
    end

    add_index :trails, :topic_id

    insert('insert into trails (topic_id, slug, trail_map, created_at, updated_at)
           (select id, slug, trail_map, created_at, updated_at from topics where featured=true)')
    select_all("select id, slug from trails") do |trail|
      update("update trails set slug='#{trail["slug"].parameterize}'
             where id=#{trail["id"]}")
    end

    remove_column :topics, :trail_map
  end

  def down
    add_column :topics, :trail_map, :text
    update('update topics set trail_map=trails.trail_map
           from trails where topic_id=topics.id')
    drop_table :trails
  end
end
