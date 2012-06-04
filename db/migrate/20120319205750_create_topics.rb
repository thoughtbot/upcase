class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.timestamps       null: false
      t.text   :body,    null: false
      t.string :keywords
      t.string :name,    null: false
      t.string :slug,    null: false
      t.text   :summary
    end

    add_index :topics, :slug, unique: true
  end
end
