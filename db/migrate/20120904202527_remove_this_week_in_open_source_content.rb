class RemoveThisWeekInOpenSourceContent < ActiveRecord::Migration
  def up
    execute <<-SQL
      DELETE FROM "articles"
      WHERE "articles"."id" IN (
        SELECT "articles"."id"
        FROM "articles" INNER JOIN "classifications" ON "classifications"."classifiable_id" = "articles"."id" AND "classifications"."classifiable_type" = 'Article'
        INNER JOIN "topics" ON "topics"."id" = "classifications"."topic_id"
        WHERE (topics.name LIKE 'this week in open source')
      );

      DELETE FROM "classifications"
      WHERE "classifications"."id" IN (
        SELECT "classifications"."id"
        FROM "classifications"
        INNER JOIN "topics" ON "topics"."id" = "classifications"."topic_id"
        WHERE (topics.name LIKE 'this week in open source')
      );

      DELETE FROM "topics"
      WHERE "topics"."name" LIKE 'this week in open source';
    SQL
  end

  def down
  end
end
