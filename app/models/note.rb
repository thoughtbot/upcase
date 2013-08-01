class Note < ActiveRecord::Base
  belongs_to :user

  validates :body, presence: true
  validates :user_id, presence: true

  def body_html
    BlueCloth.new(body).to_html
  end
end
