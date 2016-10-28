class ChangeBodyToText < ActiveRecord::Migration
  def up
    change_column :videos, :email_body_text, :text
  end

  def down
    change_column :videos, :email_body_text, :string
  end
end
