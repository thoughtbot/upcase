class RenameTestingFundamentals < ActiveRecord::Migration[5.2]
  def change
    execute <<~SQL
      UPDATE trails
       SET name='Rails Testing Exercises', slug='rails-testing-exercises'
       WHERE trails.slug='testing-fundamentals'
    SQL
  end
end
