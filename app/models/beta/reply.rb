module Beta
  class Reply < ActiveRecord::Base
    belongs_to :offer
    belongs_to :user

    validates :offer_id, presence: true
    validates :user_id, presence: true
  end
end
