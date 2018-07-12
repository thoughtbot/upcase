class AddSlugsToWorkshops < ActiveRecord::Migration[4.2]
  def change
    add_column :workshops, :slug, :string, null: true

    workshops = select_all("select id, name from workshops")
    workshops.each do |workshop|
      update(<<-SQL)
        UPDATE workshops
          SET slug='#{workshop["name"].parameterize}'
          WHERE id=#{workshop["id"]}
      SQL
    end

    change_column_null :workshops, :slug, false
    add_index :workshops, :slug, unique: true
  end
end
