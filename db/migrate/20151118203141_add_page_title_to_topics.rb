class AddPageTitleToTopics < ActiveRecord::Migration[4.2]
  def change
    add_column :topics, :page_title, :string

    backfill_page_titles

    change_column :topics, :page_title, :string, null: false
  end

  private

  def backfill_page_titles
    {
      "vim" =>  "Learn Vim | Vim Training and Tutorials",
      "rails" => "Learn Ruby on Rails | Ruby on Rails Tutorials",
      "ios" => "Learn iOS Development | iOS Development Tutorials",
      "haskell" => "Learn Haskell | Haskell Online Courses",
      "testing" => "Learn TDD | Test Driven Development Tutorials",
      "javascript" => "Learn Javascript | JS Tutorials and Courses",
      "design" => "Learn Web Design | Web Design Tutorials",
      "clean-code" => "Learn Clean Code | Clean Code Tutorials",
      "foundations" => "Learn Ruby Fundamentals",
      "workflow" => "Learn Ruby Workflows | Git, Tmux, and Dotfiles Tutorials",
      "clojure" => "Learn Clojure",
      "analytics" => "Learn Analytics",
    }.each do |slug, page_title|
      connection.update(<<-SQL)
        UPDATE topics
          SET page_title = '#{page_title}'
          WHERE slug = '#{slug}'
      SQL
    end
  end
end
