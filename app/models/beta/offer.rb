module Beta
  class Offer < ActiveRecord::Base
    has_many :replies, dependent: :destroy

    validates :name, presence: true
    validates :description, presence: true

    def self.visible_to(user)
      includes(:replies).
        references(:replies).
        where(<<-SQL, user.id)
          beta_replies.user_id <> ?
          OR beta_replies.user_id IS NULL
        SQL
    end

    def self.most_recent_first
      order(created_at: :desc)
    end
  end
end
