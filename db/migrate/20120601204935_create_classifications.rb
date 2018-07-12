class CreateClassifications < ActiveRecord::Migration[4.2]
  def change
    create_table :classifications do |t|
      t.integer :topic_id
      t.string :classifiable_type
      t.integer :classifiable_id

      t.timestamps
    end
  end
end
