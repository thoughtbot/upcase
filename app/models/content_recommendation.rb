class ContentRecommendation < ApplicationRecord
  belongs_to :user
  belongs_to :recommendable, polymorphic: true
end
