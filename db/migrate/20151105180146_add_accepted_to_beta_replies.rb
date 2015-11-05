class AddAcceptedToBetaReplies < ActiveRecord::Migration
  def change
    add_column :beta_replies, :accepted, :boolean
    change_column_null :beta_replies, :accepted, false, true
  end
end
