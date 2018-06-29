class UpdateTrailsTopics < ActiveRecord::Migration[4.2]
  def up
    create_topic name: "Foundations"

    update_trail_topic trail: "haskell-fundamentals", topic: "haskell"
    update_trail_topic trail: "refactoring", topic: "clean+code"
    update_trail_topic trail: "regular-expressions", topic: "foundations"
  end

  private

  def create_topic(name:)
    insert <<-SQL.squish
      INSERT INTO topics (name, slug, created_at, updated_at)
      VALUES ('#{name}', '#{name.parameterize}', NOW(), NOW())
    SQL
  end

  def update_trail_topic(trail:, topic:)
    update <<-SQL.squish
      UPDATE trails
      SET topic_id = (SELECT id FROM topics WHERE "slug" = '#{topic}')
      WHERE "slug" = '#{trail}'
    SQL
  end
end
