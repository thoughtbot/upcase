class AddMailerFieldsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :email_subject, :string
    add_column :videos, :email_body_text, :string
    add_column :videos, :email_cta_label, :string
  end
end
