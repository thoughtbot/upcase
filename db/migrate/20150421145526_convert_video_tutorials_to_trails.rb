class ConvertVideoTutorialsToTrails < ActiveRecord::Migration[4.2]
  def up
    trail_offset = say_with_time "Calculating ID offset for new trails" do
      select_value("SELECT COUNT(*) FROM trails").to_i
    end

    say_with_time "Creating trails for video tutorials" do
      insert(<<-SQL.squish)
        INSERT INTO trails (
          id,
          name,
          created_at,
          updated_at,
          complete_text,
          published,
          slug,
          description,
          topic_id
        )
        SELECT
          id + #{trail_offset} AS id,
          name,
          created_at,
          updated_at,
          'Way to go!' AS complete_text,
          active,
          slug,
          COALESCE(short_description, '') AS description,
          COALESCE(
            (
              SELECT topic_id
              FROM classifications
              WHERE classifications.classifiable_id = products.id
              AND classifications.classifiable_type IN(
                'Product',
                'VideoTutorial'
              )
              LIMIT 1
            ),
            (
              SELECT id
              FROM topics
              WHERE explorable = true
              LIMIT 1
            )
          ) AS topic_id
        FROM products
        WHERE products.type = 'VideoTutorial'
        AND active
      SQL
    end

    say_with_time "Creating steps for videos" do
      insert(<<-SQL.squish)
        INSERT INTO steps (
          trail_id,
          completeable_id,
          completeable_type,
          position,
          created_at,
          updated_at
        )
        SELECT
          watchable_id + #{trail_offset} AS trail_id,
          id AS completeable_id,
          'Video' AS completeable_type,
          position,
          created_at,
          updated_at
        FROM videos
        WHERE watchable_type = 'Product'
      SQL
    end

    say_with_time "Removing watchables from trail videos" do
      update(<<-SQL.squish)
        UPDATE videos
        SET watchable_id = NULL, watchable_type = NULL
        FROM products
        WHERE watchable_type = 'Product'
        AND watchable_id = products.id
        AND products.type = 'VideoTutorial'
      SQL
    end

    say_with_time "Fixing repository references to video tutorials" do
      update(<<-SQL.squish)
        UPDATE products
        SET trail_id = products.product_id + #{trail_offset},
          product_id = NULL
        FROM products parent_products
        WHERE products.product_id = parent_products.id
        AND parent_products.type = 'VideoTutorial'
      SQL
    end

    say_with_time "Deleting video tutorials" do
      delete("DELETE FROM products WHERE type = 'VideoTutorial'")
    end

    say_with_time "Deleting video tutorial references" do
      polymorphic_delete :classifications, as: :classifiable
      polymorphic_delete :downloads, as: :purchaseable
      polymorphic_delete :videos, as: :watchable
    end

    say_with_time "Unpublishing video trails with only one step" do
      update(<<-SQL.squish)
        UPDATE trails
        SET published = false
        WHERE (SELECT COUNT(*) FROM steps WHERE steps.trail_id = trails.id) < 2
      SQL
    end
  end

  def down
  end

  private

  def polymorphic_delete(table, as:)
    delete(<<-SQL.squish)
      DELETE FROM #{table}
      USING products
      WHERE #{table}.#{as}_id = products.id
      AND #{table}.#{as}_type IN('Product', 'VideoTutorial')
      AND products.type = 'VideoTutorial'
    SQL
  end
end
