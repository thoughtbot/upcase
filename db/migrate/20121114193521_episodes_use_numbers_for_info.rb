class EpisodesUseNumbersForInfo < ActiveRecord::Migration[4.2]
  def up
    remove_column :episodes, :size
    remove_column :episodes, :length
    add_column :episodes, :duration, :integer
  end

  def down
    remove_column :episodes, :duration
    add_column :episodes, :size, :string
    add_column :episodes, :length, :string
  end
end
