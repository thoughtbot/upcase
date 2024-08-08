class RemoveInpersonWorkshops < ActiveRecord::Migration[4.2]
  def up
    ip_workshops = select_all "SELECT * FROM workshops WHERE online = false"
    ip_workshops.each do |ip_workshop|
      online_workshop = select_one(<<-EOS)
        SELECT * FROM workshops
          WHERE online = true AND name = '#{ip_workshop["name"]}'
      EOS
      if online_workshop
        update(<<-EOS)
          UPDATE sections
            SET workshop_id=#{online_workshop["id"]}
            WHERE workshop_id = #{ip_workshop["id"]}
        EOS
        delete "DELETE FROM workshops WHERE id=#{ip_workshop["id"]}"
      end
    end

    workshops = select_all(<<-EOS)
      SELECT workshops.id, purchases.id AS purchaseid
        FROM workshops
          JOIN sections ON workshops.id = sections.workshop_id
          JOIN purchases ON
            purchases.purchaseable_type = 'Section'
            AND sections.id = purchases.purchaseable_id
    EOS
    workshops.each do |workshop|
      update(<<-EOS)
      UPDATE purchases
        SET purchaseable_type = 'Workshop', purchaseable_id = #{workshop["id"]}
        WHERE purchases.id = #{workshop["purchaseid"]}
      EOS
    end

    remove_column :workshops, :maximum_students
    remove_column :workshops, :online
    remove_column :purchases, :comments

    drop_table :sections
    drop_table :section_teachers
    drop_table :teachers
    drop_table :follow_ups
  end

  def down
    add_column :workshops, :maximum_students, :integer
    add_column :workshops, :online, :boolean, default: false, null: false
    add_column :purchases, :comments, :text

    create_table :sections do |t|
      t.integer :workshop_id
      t.date :starts_on
      t.date :ends_on
      t.integer :seats_available
      t.time :start_at
      t.time :stop_at
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.timestamps
    end
    create_table :section_teachers do |t|
      t.integer :section_id
      t.integer :teacher_id
      t.timestamps
    end
    create_table :teachers do |t|
      t.string :name
      t.string :gravatar_hash
      t.text :bio
      t.string :email
      t.timestamps
    end
    create_table :follow_ups do |t|
      t.string :email
      t.integer :workshop_id
      t.datetime :notified_at
      t.timestamps
    end

    workshops = select_all "SELECT * FROM workshops"
    workshops.each do |workshop|
      section_id = insert("INSERT INTO sections (workshop_id, starts_on) VALUES (#{workshop["id"]}, NOW())")
      update(<<-EOS)
        UPDATE purchases
          SET purchaseable_type='Section', purchaseable_id=#{section_id}
          WHERE purchaseable_type='Workshop' AND
            purchaseable_id=#{workshop["id"]}
      EOS
    end
  end
end
