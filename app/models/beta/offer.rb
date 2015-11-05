module Beta
  class Offer < ActiveRecord::Base
    has_many :replies, dependent: :destroy

    validates :name, presence: true
    validates :description, presence: true

    def self.most_recent_first
      order(created_at: :desc)
    end
  end
end
