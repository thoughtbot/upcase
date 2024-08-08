class AddNumberToEpisodes < ActiveRecord::Migration[4.2]
  def change
    add_column :episodes, :number, :integer
    add_index :episodes, :number

    update "update episodes set number = id"
  end
end
