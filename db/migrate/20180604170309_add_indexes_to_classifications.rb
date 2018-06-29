class AddIndexesToClassifications < ActiveRecord::Migration[4.2]
  def change
    add_index :classifications, :topic_id
    add_index :classifications, [:classifiable_id, :classifiable_type]
  end
end
