class AddNumberToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :number, :integer
    add_index :episodes, :number

    update 'update episodes set number = id'
  end
end
