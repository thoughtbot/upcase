class CreateSlugs < ActiveRecord::Migration[4.2]
  def change
    create_view :slugs
  end
end
