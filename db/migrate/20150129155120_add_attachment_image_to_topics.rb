class AddAttachmentImageToTopics < ActiveRecord::Migration
  def up
    change_table :topics do |t|
      t.attachment :image
    end
  end

  def down
    remove_attachment :topics, :image
  end
end
