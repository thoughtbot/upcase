class CreateSlugs < ActiveRecord::Migration
  def change
    create_view :slugs
  end
end
