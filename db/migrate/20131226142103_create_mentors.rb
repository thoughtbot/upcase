class CreateMentors < ActiveRecord::Migration[4.2]
  def up
    create_table :mentors do |t|
      t.belongs_to :user, null: false
      t.string :availability, default: "11am to 5pm on Fridays", null: false
    end
    add_index :mentors, :user_id

    mentors = select_all('SELECT id, availability FROM users WHERE available_to_mentor = true')
    mentors.each do |mentor|
      id = insert("INSERT into mentors (user_id, availability) VALUES (#{mentor['id']}, #{quote(mentor['availability'])})")
      update "UPDATE users SET mentor_id=#{id} WHERE mentor_id=#{mentor['id']}"
    end

    remove_column :users, :available_to_mentor
    remove_column :users, :availability
  end

  def down
    add_column :users, :available_to_mentor, :boolean, default: false, null: false
    add_column :users, :availability, :string, default: "11am to 5pm on Fridays", null: false

    mentors = select_all('SELECT user_id, availability FROM mentors')
    mentors.each do |mentor|
      update <<-SQL
        UPDATE users
        SET
          available_to_mentor=true,
          availability=#{quote(mentor['availability'])}
        WHERE id=#{mentor['user_id']}
      SQL
    end

    drop_table :mentors
  end
end
