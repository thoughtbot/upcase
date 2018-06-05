module Beta
  class Offer < ApplicationRecord
    has_many :replies, dependent: :destroy

    validates :name, presence: true
    validates :description, presence: true

    def self.most_recent_first
      order(created_at: :desc)
    end

    def self.active
      where(active: true)
    end

    def reply(user:, accepted:)
      replies.create!(user: user, accepted: accepted)
    end
  end
end
