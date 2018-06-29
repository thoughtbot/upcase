class UpdateTopicColors < ActiveRecord::Migration[4.2]
  COLORS = {
    analytics:                   ["#EFFFB3", "#A5C236"],
    "clean+code" =>              ["#E5FEFF", "#1DC8CF"],
    clojure:                     ["#FFD3BC", "#ED6820"],
    design:                      ["#E8E9FF", "#2B2F8E"],
    foundations:                 ["#DAFFCB", "#77C159"],
    haskell:                     ["#FFE7FD", "#CD6FC6"],
    ios:                         ["#D7ECFF", "#396189"],
    javascript:                  ["#FFE8CA", "#D87D2F"],
    rails:                       ["#FFECEE", "#D5414D"],
    "test-driven+development" => ["#E5FDF4", "#34D096"],
    vim:                         ["#E1F5FF", "#2192CF"],
    workflow:                    ["#FCF5C8", "#F4BC15"]
  }

  def up
    add_column :topics, :color, :string, default: "", null: false
    add_column :topics, :color_accent, :string, default: "", null: false

    create_topic(name: "Analytics")
    create_topic(name: "Clojure")

    COLORS.each { |slug, colors| update_topic(slug, colors) }
  end

  def down
    drop_topic(name: "Analytics")
    drop_topic(name: "Clojure")
    remove_column :topics, :color
    remove_column :topics, :color_accent
  end

  private

  def create_topic(name:)
    insert <<-SQL.squish
      INSERT INTO topics (name, slug, created_at, updated_at)
      VALUES ('#{name}', '#{name.parameterize}', NOW(), NOW())
    SQL
  end

  def update_topic(slug, colors)
    update <<-SQL.squish
      UPDATE topics
        SET color = '#{colors[0]}', color_accent = '#{colors[1]}'
        WHERE slug = '#{slug}'
    SQL
  end

  def drop_topic(name:)
    delete "DELETE FROM topics WHERE name = '#{name}'"
  end
end
