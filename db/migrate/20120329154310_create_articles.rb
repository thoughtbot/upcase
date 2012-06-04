class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.timestamps              null: false
      t.string     :title,      null: false
      t.text       :body,       null: false
      t.string     :tumblr_url, null: false
    end
  end
end
